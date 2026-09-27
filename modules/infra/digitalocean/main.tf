# Condition to use an existing keypair if a keypair name and file is also provided
locals {
  new_key_pair_path = var.ssh_private_key_path != null ? var.ssh_private_key_path : "${path.cwd}/${var.prefix}-ssh_private_key.pem"
  all_droplet_ids   = var.rke2_installation ? concat(digitalocean_droplet.droplet[*].id, var.extra_droplet_id) : digitalocean_droplet.droplet[*].id

  # Use the caller's VPC when one is passed in; otherwise create one alongside the firewall
  create_vpc   = var.vpc == null && var.create_firewall
  vpc_uuid     = var.vpc != null ? var.vpc.id : (local.create_vpc ? digitalocean_vpc.k8s_cluster[0].id : null)
  vpc_ip_range = var.vpc != null ? var.vpc.ip_range : (local.create_vpc ? digitalocean_vpc.k8s_cluster[0].ip_range : null)
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

resource "digitalocean_vpc" "k8s_cluster" {
  count  = local.create_vpc ? 1 : 0
  name   = "${var.prefix}-vpc"
  region = var.region
}

data "digitalocean_regions" "available" {
  filter {
    key    = "available"
    values = ["true"]
  }
}

resource "digitalocean_droplet" "droplet" {
  count      = var.droplet_count
  image      = var.os_type == "opensuse" ? data.digitalocean_image.opensuse[0].id : data.digitalocean_image.ubuntu[0].id
  size       = var.droplet_size
  name       = "${var.prefix}-${count.index + var.tag_begin}"
  tags       = var.tags != null ? var.tags : ["user:${var.prefix}", "creator:${var.prefix}"]
  ssh_keys   = var.create_ssh_key_pair ? [digitalocean_ssh_key.key_pair[0].id] : [data.digitalocean_ssh_key.terraform.id]
  user_data  = var.user_data
  region     = var.region
  vpc_uuid   = local.vpc_uuid
  depends_on = [tls_private_key.ssh_private_key, local_file.private_key_pem, digitalocean_ssh_key.key_pair]

  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = var.create_ssh_key_pair ? tls_private_key.ssh_private_key[0].private_key_openssh : (var.create_ssh_key_pair == false && var.ssh_key_pair_path == null && var.rke2_installation == true ? file(pathexpand(local.new_key_pair_path)) : file(pathexpand(var.ssh_key_pair_path)))
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = flatten([
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
      var.os_type == "opensuse" ? [
        "echo 'installing iptables package (openSUSE)'",
        "zypper --non-interactive refresh > /dev/null 2>&1",
        "zypper --non-interactive install iptables > /dev/null 2>&1"
      ] : []
    ])
  }

  lifecycle {
    create_before_destroy = true
    # SSH keys are only injected at creation; a deferred key lookup must not force a rebuild
    ignore_changes = [image, ssh_keys]
  }
}

resource "digitalocean_loadbalancer" "k8s_api_loadbalancer" {
  count    = var.create_k8s_api_loadbalancer ? 1 : 0
  name     = "${var.prefix}-6443-lb"
  region   = var.region
  vpc_uuid = local.vpc_uuid

  forwarding_rule {
    entry_port     = 443
    entry_protocol = "https"

    target_port     = 6443
    target_protocol = "https"

    tls_passthrough = true
  }

  healthcheck {
    port     = 6443
    protocol = "tcp"
  }

  droplet_ids = local.all_droplet_ids
  depends_on  = [digitalocean_droplet.droplet]
}

resource "digitalocean_loadbalancer" "https_loadbalancer" {
  count    = var.create_https_loadbalancer ? 1 : 0
  name     = "${var.prefix}-443-lb"
  region   = var.region
  vpc_uuid = local.vpc_uuid

  forwarding_rule {
    entry_port     = 443
    entry_protocol = "https"

    target_port     = 443
    target_protocol = "https"

    tls_passthrough = true
  }

  healthcheck {
    port     = 443
    protocol = "tcp"
  }

  droplet_ids = local.all_droplet_ids
  depends_on  = [digitalocean_droplet.droplet]
}

resource "digitalocean_firewall" "k8s_cluster" {
  count = var.create_firewall ? 1 : 0
  name  = "${var.prefix}-allow-nodes"

  droplet_ids = local.all_droplet_ids
  depends_on  = [digitalocean_droplet.droplet]

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
    protocol         = "tcp"
    port_range       = "9345"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "1-65535"
    source_addresses = [local.vpc_ip_range]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "1-65535"
    source_addresses = [local.vpc_ip_range]
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = [local.vpc_ip_range]
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

  lifecycle {
    create_before_destroy = true
  }
}
