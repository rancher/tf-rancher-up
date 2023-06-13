data "template_file" "config_server_yaml" {
  template = file("../../../../modules/distribution/rke2/file_templates/config_server.yaml.tpl")
  vars = {
    rke2_token = var.rke2_token
    public_ip  = var.rancher_nodes[0].private_ip
  }
}

data "template_file" "config_other_yaml" {
  template = file("../../../../modules/distribution/rke2/file_templates/config_other.yaml.tpl")
  vars = {
    rke2_token = var.rke2_token
    server     = var.rancher_nodes[0].private_ip
  }
}


resource "null_resource" "rke2_common" {

  count = var.cp_vm_count



  provisioner "remote-exec" {

    connection {
      type        = "ssh"
      user        = var.node_username
      private_key = file("${var.ssh_private_key_path}")
      host        = var.rancher_nodes[count.index].public_ip
    }
    inline = [
      "sudo mkdir -p /etc/rancher/rke2",
      "sudo mkdir -p /var/lib/rancher/rke2/server/manifests",
      "sudo mkdir -p /var/lib/rancher/rke2/agent/images",
      "sudo mkdir -p /opt/rke2",
    ]
  }
}



resource "null_resource" "rke2_server1_provisioning" {


  provisioner "file" {
    content     = data.template_file.config_server_yaml.rendered
    destination = "/tmp/config.yaml"

    connection {
      type        = "ssh"
      user        = var.node_username
      private_key = file("${var.ssh_private_key_path}")
      host        = var.rancher_nodes[0].public_ip
    }
  }


  provisioner "remote-exec" {

    connection {
      type        = "ssh"
      user        = var.node_username
      private_key = file("${var.ssh_private_key_path}")
      host        = var.rancher_nodes[0].public_ip
    }
    inline = [
      "sudo cp /tmp/config.yaml /etc/rancher/rke2",
      "sudo bash -c 'curl  https://get.rke2.io | INSTALL_RKE2_TYPE=\"server\" INSTALL_RKE2_VERSION=${var.rancher_kubernetes_version} sh -'",
      "sudo systemctl enable rke2-server",
      "sudo systemctl start rke2-server"
    ]
  }

}



### Waiting between first server and others
resource "time_sleep" "sleep_between_first_server_and_others" {

  depends_on = [
    null_resource.rke2_server1_provisioning
  ]

  create_duration = "30s"

}


### Setting up the after-first servers
resource "null_resource" "rke2_servers_others_provisioning" {

  count = var.cp_vm_count - 1
  depends_on = [
    time_sleep.sleep_between_first_server_and_others
  ]

  provisioner "file" {
    content     = data.template_file.config_other_yaml.rendered
    destination = "/tmp/config.yaml"

    connection {
      type        = "ssh"
      user        = var.node_username
      private_key = file("${var.ssh_private_key_path}")
      host        = var.rancher_nodes[count.index + 1].public_ip
    }
  }

  provisioner "remote-exec" {

    connection {
      type        = "ssh"
      user        = var.node_username
      private_key = file("${var.ssh_private_key_path}")
      host        = var.rancher_nodes[count.index + 1].public_ip
    }

    inline = [
      "sudo cp /tmp/config.yaml /etc/rancher/rke2",
      "sudo bash -c 'curl  https://get.rke2.io | INSTALL_RKE2_TYPE=\"server\" INSTALL_RKE2_VERSION=${var.rancher_kubernetes_version} sh -'",
      "sudo systemctl enable rke2-server",
      "sudo systemctl start rke2-server",
    ]
    on_failure = continue
  }

}

resource "ssh_resource" "retrieve_config" {
  depends_on = [
    null_resource.rke2_server1_provisioning
  ]
  host = var.rancher_nodes[0].public_ip
  commands = [
    "sudo sed 's/127.0.0.1/${var.rancher_nodes[0].public_ip}/g' /etc/rancher/rke2/rke2.yaml"
  ]
  user        = "${var.node_username}"
  private_key = file("${var.ssh_private_key_path}")
}

resource "local_file" "kube_config_server_yaml" {
  filename = format("%s/%s", path.module, "kube_config_server.yaml")
  content  = ssh_resource.retrieve_config.result
}

