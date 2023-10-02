resource "digitalocean_droplet" "droplet" {
  count     = var.droplet_count
  image     = data.digitalocean_image.ubuntu.id
  size      = var.droplet_size
  name      = "${var.prefix}-${count.index + var.tag_begin}"
  tags      = ["user:${var.user_tag}", "creator:${var.prefix}"]
  ssh_keys  = [data.digitalocean_ssh_key.terraform.id]
  user_data = var.user_data
  region    = var.region

  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.ssh_private_key_path)
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