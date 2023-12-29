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
  filename        = local.new_key_pair_path
  content         = tls_private_key.ssh_private_key[0].private_key_openssh
  file_permission = "0600"
}

resource "local_file" "public_key_pem" {
  count           = var.create_ssh_key_pair ? 1 : 0
  filename        = "${path.cwd}/${var.prefix}-ssh_public_key.pem"
  content         = tls_private_key.ssh_private_key[0].public_key_openssh
  file_permission = "0600"
}

resource "google_compute_network" "vpc" {
  count                   = var.vpc == null ? 1 : 0
  name                    = "${var.prefix}-vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet" {
  count         = var.subnet == null ? 1 : 0
  name          = "${var.prefix}-subnet"
  region        = var.region
  network       = var.vpc == null ? resource.google_compute_network.vpc[0].name : var.vpc
  ip_cidr_range = var.ip_cidr_range
}

resource "google_compute_firewall" "default" {
  count   = var.create_firewall == true ? 1 : 0
  name    = "${var.prefix}-firewall"
  network = var.vpc == null ? resource.google_compute_network.vpc[0].name : var.vpc

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    # https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/installation-requirements/port-requirements
    ports = ["22", "443", "6443", "2379", "2380", "8443", "9099", "10250", "10254", "2376"]
  }

  allow {
    protocol = "tcp"
    # https://docs.rke2.io/install/requirements#inbound-network-rules
    ports = ["30000-32767"]
  }

  allow {
    protocol = "tcp"
    # https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-socket-option
    ports = ["2375", "2376"]
  }

  allow {
    protocol = "udp"
    # https://ranchermanager.docs.rancher.com/getting-started/installation-and-upgrade/installation-requirements/port-requirements
    ports = ["8472"]
  }

  allow {
    protocol = "tcp"
    # https://docs.rke2.io/install/requirements#inbound-network-rules
    ports = ["9345", "6443", "10250", "2379", "2380", "2381", "9099"]
  }

  allow {
    protocol = "udp"
    # https://docs.rke2.io/install/requirements#inbound-network-rules
    ports = ["8472", "8472", "51820", "51821"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.prefix}"]
}

data "google_compute_zones" "available" {
  region = var.region
}

resource "random_string" "random" {
  length  = 4
  lower   = true
  numeric = false
  special = false
  upper   = false
}

resource "google_compute_instance" "default" {
  count        = var.instance_count
  name         = "${var.prefix}-vm-${count.index + 1}-${random_string.random.result}"
  machine_type = var.instance_type
  zone         = data.google_compute_zones.available.names[count.index % 3]

  tags = ["${var.prefix}"]

  boot_disk {
    initialize_params {
      size  = var.instance_disk_size
      type  = var.disk_type
      image = var.os_image
    }
  }

  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network    = var.vpc == null ? resource.google_compute_network.vpc[0].name : var.vpc
    subnetwork = var.subnet == null ? resource.google_compute_subnetwork.subnet[0].name : var.subnet
    access_config {}
  }

  metadata = {
    ssh-keys       = var.ssh_public_key_path == null ? "${var.ssh_username}:${file("${path.cwd}/${var.prefix}-ssh_public_key.pem")}" : "${var.ssh_username}:${file("${var.ssh_public_key_path}")}"
    startup-script = var.startup_script
  }
}
