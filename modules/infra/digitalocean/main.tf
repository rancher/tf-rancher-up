# Condition to use an existing keypair if a keypair name and file is also provided
locals {
  new_key_pair_path = var.ssh_private_key_path != null ? var.ssh_private_key_path : "${path.cwd}/${var.prefix}-ssh_private_key.pem"
}

resource "tls_private_key" "ssh_private_key" {
  count     = var.create_ssh_key_pair ? 1 : 0
  algorithm = "ED25519"
}

resource "local_file" "private_key_pem" {
  count           = var.create_ssh_key_pair ? 1 : 0
  filename        = pathexpand(local.new_key_pair_path)
  content         = tls_private_key.ssh_private_key[0].private_key_openssh
  file_permission = "0600"
}

resource "digitalocean_ssh_key" "key_pair" {
  count      = var.create_ssh_key_pair ? 1 : 0
  name       = "tf-rancher-up-${var.prefix}"
  public_key = tls_private_key.ssh_private_key[0].public_key_openssh
}

resource "digitalocean_droplet" "droplet" {
  count      = var.droplet_count
  image      = data.digitalocean_image.ubuntu.id
  size       = var.droplet_size
  name       = "${var.prefix}-${count.index + var.tag_begin}"
  tags       = ["user:${var.user_tag}", "creator:${var.prefix}"]
  ssh_keys   = var.create_ssh_key_pair ? [digitalocean_ssh_key.key_pair[0].id] : [data.digitalocean_ssh_key.terraform.id]
  user_data  = var.user_data
  region     = var.region
  depends_on = [tls_private_key.ssh_private_key, local_file.private_key_pem, digitalocean_ssh_key.key_pair]

  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = var.create_ssh_key_pair ? tls_private_key.ssh_private_key[0].private_key_openssh : file(pathexpand(var.ssh_key_pair_path))
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = flatten([
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'"
    ])
  }
}

resource "digitalocean_firewall" "k8s_cluster" {
  name = "${var.prefix}-allow-nodes"

  droplet_ids = resource.digitalocean_droplet.droplet[*].id

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "6443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol           = "tcp"
    port_range         = "1-65535"
    source_droplet_ids = resource.digitalocean_droplet.droplet[*].id
  }

  inbound_rule {
    protocol           = "udp"
    port_range         = "1-65535"
    source_droplet_ids = resource.digitalocean_droplet.droplet[*].id
  }

  inbound_rule {
    protocol           = "icmp"
    source_droplet_ids = resource.digitalocean_droplet.droplet[*].id
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  depends_on = [digitalocean_droplet.droplet]
}
