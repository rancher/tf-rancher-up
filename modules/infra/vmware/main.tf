provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = var.vsphere_server_allow_unverified_ssl
}

resource "vsphere_virtual_machine" "instance" {
  count = var.instance_count

  name             = "${var.prefix}-rke-h${count.index + 1}"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = var.vm_cpus
  memory           = var.vm_memory
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
    size             = 80
    unit_number      = 0
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks[0].eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks[0].thin_provisioned
  }

  provisioner "remote-exec" {
    connection {
      host        = self.default_ip_address
      type        = "ssh"
      user        = var.vm_username
      private_key = file(pathexpand(var.ssh_private_key_path))

    }
    inline = [
      "export DEBIAN_FRONTEND=noninteractive;sudo curl -sSL https://releases.rancher.com/install-docker/${var.docker_version}.sh | sh -",
      "sudo usermod -aG docker ubuntu"
    ]
  }

  extra_config = {
    "guestinfo.metadata" = base64encode(templatefile("${path.module}/metadata.yml.tpl", {
      node_hostname = "${var.prefix}${count.index + 1}"
    }))
    "guestinfo.metadata.encoding" = "base64"
    "guestinfo.userdata" = base64encode(templatefile("${path.module}/cloud-init.template", {
      vm_ssh_user = var.vm_username,
      vm_ssh_key  = var.authorized_keys
    }))
    "guestinfo.userdata.encoding" = "base64"
  }
}
