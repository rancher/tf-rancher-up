# VMware Infrastructure Module - Main Configuration
# Provisions VMs on vSphere with cloud-init support

locals {
  # Generate SSH key if requested
  ssh_private_key_path = var.create_ssh_key_pair ? "${path.cwd}/${var.prefix}-ssh_private_key.pem" : var.ssh_private_key_path

  # Use provided user_data or generate default cloud-init
  effective_user_data = var.user_data != null ? var.user_data : templatefile("${path.module}/cloud-init-default.yaml.tpl", {
    vm_username    = var.vm_username
    ssh_public_key = var.ssh_public_key
  })
}

# Generate SSH key pair if requested
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

# Wait resource to allow VM boot and cloud-init to start
resource "time_sleep" "vm_boot" {
  count           = var.instance_count
  create_duration = "30s"
}

# Provision VMs
resource "vsphere_virtual_machine" "instance" {
  count = var.instance_count

  name             = "${var.prefix}-${var.start_index + count.index}"
  resource_pool_id = local.resource_pool_id # Uses cluster, host, or explicit pool
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = var.vsphere_folder # Optional folder for VM organization
  num_cpus         = var.vm_cpus
  memory           = var.vm_memory
  firmware         = var.vsphere_firmware != null ? var.vsphere_firmware : data.vsphere_virtual_machine.template.firmware
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  scsi_type        = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  cdrom {
    client_device = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }

  disk {
    label            = "disk0"
    size             = var.vm_disk
    unit_number      = 0
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks[0].eagerly_scrub
    thin_provisioned = true
  }



  # Cloud-init configuration via VMware guestinfo
  extra_config = {
    "guestinfo.metadata" = base64encode(templatefile("${path.module}/metadata.yaml.tpl", {
      hostname = "${var.prefix}-${var.start_index + count.index}"
    }))
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata"          = base64encode(local.effective_user_data)
    "guestinfo.userdata.encoding" = "base64"
  }

  # Wait for cloud-init to complete
  provisioner "remote-exec" {
    connection {
      host        = self.default_ip_address
      type        = "ssh"
      user        = var.vm_username
      private_key = var.create_ssh_key_pair ? tls_private_key.ssh_key[0].private_key_openssh : (var.ssh_private_key != null ? var.ssh_private_key : file(pathexpand(var.ssh_private_key_path)))
      timeout     = "10m"
    }

    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait || true",
      "sleep 10",
      "echo 'Cloud-init completed!'"
    ]
  }

  depends_on = [time_sleep.vm_boot]
}