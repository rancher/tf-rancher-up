locals {
  ssh_private_key_path = var.create_ssh_key_pair ? "${path.cwd}/${var.prefix}-ssh_private_key.pem" : var.ssh_private_key_path

  effective_user_data = var.user_data != null ? var.user_data : templatefile("${path.module}/cloud-init-default.yaml.tpl", {
    vm_username    = var.vm_username
    ssh_public_key = var.ssh_public_key
  })

  # Static IP per instance index, falling back to "" (DHCP) when not provided
  # or when the list doesn't have an entry for this index.
  ip_addresses_by_index = { for idx, ip in var.ip_addresses : idx => ip }
}

resource "tls_private_key" "ssh_key" {
  count     = var.create_ssh_key_pair ? 1 : 0
  algorithm = "ED25519"
}

resource "local_file" "private_key" {
  count           = var.create_ssh_key_pair ? 1 : 0
  filename        = local.ssh_private_key_path
  content         = tls_private_key.ssh_key[0].private_key_openssh
  file_permission = "0600"
}

resource "vsphere_virtual_machine" "instance" {
  count = var.instance_count

  name             = "${var.prefix}-${var.start_index + count.index}"
  resource_pool_id = local.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = var.vsphere_folder
  num_cpus         = var.vm_cpus
  memory           = var.vm_memory

  # vCenter (clone) path: firmware and guest_id come from the template.
  # OVF deploy path: firmware is read from the OVA itself (null = let OVA decide).
  firmware  = var.use_ovf_deploy ? var.vsphere_firmware : (var.vsphere_firmware != null ? var.vsphere_firmware : data.vsphere_virtual_machine.template[0].firmware)
  guest_id  = var.use_ovf_deploy ? null : data.vsphere_virtual_machine.template[0].guest_id
  scsi_type = var.use_ovf_deploy ? null : data.vsphere_virtual_machine.template[0].scsi_type

  # OVF deploy requires these; ignored (optional) for clone.
  host_system_id = var.use_ovf_deploy && var.vsphere_host != null ? data.vsphere_host.host[0].id : null
  datacenter_id  = var.use_ovf_deploy ? data.vsphere_datacenter.dc.id : null

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = var.use_ovf_deploy ? var.network_adapter_type : data.vsphere_virtual_machine.template[0].network_interface_types[0]
  }

  # ── vCenter clone path (use_ovf_deploy = false, default) ──────────────────
  # Requires a pre-existing cloud-init-capable VM template in vCenter.
  dynamic "clone" {
    for_each = var.use_ovf_deploy ? [] : [1]
    content {
      template_uuid = data.vsphere_virtual_machine.template[0].id
    }
  }

  dynamic "cdrom" {
    for_each = var.use_ovf_deploy ? [] : [1]
    content {
      client_device = true
    }
  }

  # Disk for clone path: inherits template eagerly_scrub setting.
  dynamic "disk" {
    for_each = var.use_ovf_deploy ? [] : [1]
    content {
      label            = "disk0"
      size             = var.vm_disk
      unit_number      = 0
      eagerly_scrub    = data.vsphere_virtual_machine.template[0].disks[0].eagerly_scrub
      thin_provisioned = true
    }
  }

  # ── Standalone ESXi / OVF deploy path (use_ovf_deploy = true) ─────────────
  # Deploys directly from an OVA/OVF URL. No vCenter required.
  # ova_url supports:
  #   https://... — provider fetches at deploy time (CI/CD, no pre-download)
  #   file:///... — local path (faster for repeated local testing)
  dynamic "ovf_deploy" {
    for_each = var.use_ovf_deploy ? [1] : []
    content {
      local_ovf_path            = startswith(var.ova_url, "file://") ? trimprefix(var.ova_url, "file://") : null
      remote_ovf_url            = startswith(var.ova_url, "file://") ? null : var.ova_url
      allow_unverified_ssl_cert = var.vsphere_allow_unverified_ssl
      disk_provisioning         = "thin"
      ip_protocol               = "IPV4"
      # "VM Network" is the network label declared in the OVF NetworkSection of
      # standard Ubuntu/RHEL cloud images. It maps to the vSphere network specified
      # by vsphere_network. Custom OVAs with a different internal label are not
      # supported by this module — use a standard cloud image OVA instead.
      ovf_network_map = {
        "VM Network" = data.vsphere_network.network.id
      }
    }
  }

  # Disk resize for OVF path: OVA ships with a small native disk (~9GB for
  # Ubuntu cloud images). This block resizes it to vm_disk GB after deploy.
  # The provisioner below then expands the partition to fill the new size.
  dynamic "disk" {
    for_each = var.use_ovf_deploy ? [1] : []
    content {
      label            = "Hard disk 1"
      size             = var.vm_disk
      thin_provisioned = true
      # ESXi reports 1000 shares for the default "normal" io_share_level, but
      # the provider defaults io_share_count to 0, causing a perpetual in-place
      # update on every plan. Pin it to what ESXi reports.
      io_share_count = 1000
    }
  }

  # ── Shared: cloud-init metadata + userdata ────────────────────────────────
  extra_config = {
    "guestinfo.metadata" = base64encode(templatefile("${path.module}/metadata.yaml.tpl", {
      hostname    = "${var.prefix}-${var.start_index + count.index}"
      ip_address  = var.use_ovf_deploy ? lookup(local.ip_addresses_by_index, count.index, "") : ""
      ip_gateway  = var.ip_gateway
      dns_servers = var.dns_servers
    }))
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = base64encode(local.effective_user_data)
    "guestinfo.userdata.encoding" = "base64"
  }

  provisioner "remote-exec" {
    connection {
      host        = self.default_ip_address
      type        = "ssh"
      user        = var.vm_username
      private_key = var.create_ssh_key_pair ? tls_private_key.ssh_key[0].private_key_openssh : (var.ssh_private_key != null ? var.ssh_private_key : file(pathexpand(var.ssh_private_key_path)))
      timeout     = "10m"
    }

    inline = concat(
      [
        "echo 'Waiting for cloud-init to complete...'",
        "cloud-init status --wait || true",
        "sleep 10",
        "echo 'Cloud-init completed!'",
      ],
      # OVF path only: rescan disk and expand root partition to fill vm_disk.
      var.use_ovf_deploy ? [
        "echo 'Expanding root disk...'",
        "sudo sh -c 'echo 1 > /sys/class/block/sda/device/rescan'",
        "sudo growpart /dev/sda 1 || true",
        "sudo resize2fs /dev/sda1 || true",
        "df -h /",
      ] : []
    )
  }
}
