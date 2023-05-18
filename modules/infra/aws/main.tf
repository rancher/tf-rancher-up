resource "tls_private_key" "global_key" {
  count = var.should_create_ssh_key_pair ? 1 : 0
  algorithm = "ED25519"
}

# Temporary key pair used for SSH access
resource "aws_key_pair" "key_pair" {
  count = var.should_create_ssh_key_pair ? 1 : 0
  key_name_prefix = "${var.prefix}-"
  public_key      = tls_private_key.global_key[0].public_key_openssh
}

# Security group to allow all traffic
resource "aws_security_group" "sg_allowall" {
  count = var.should_create_security_group ? 1 : 0

  name        = "${var.prefix}-allowall"
  description = "Allow all traffic"

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Creator = var.prefix
  }
}

resource "aws_instance" "instance" {
  count = var.instance_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  key_name        = var.should_create_ssh_key_pair ? aws_key_pair.key_pair[0].key_name : var.instance_ssh_key_name
  security_groups = [var.should_create_security_group ? aws_security_group.sg_allowall[0].name : var.instance_security_group ]

  root_block_device {
    volume_size = var.instance_disk_size
  }

  # TODO: Fix the hard coding of the docker version
  provisioner "remote-exec" {
    inline = flatten([
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
      "echo 'Installing Docker'",
      var.should_install_docker ? ["export DEBIAN_FRONTEND=noninteractive;curl -sSL https://releases.rancher.com/install-docker/20.10.sh | sh -; sudo usermod -aG docker ${local.node_username}"] : [],
    ])

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = local.node_username
      private_key = var.should_create_ssh_key_pair ? tls_private_key.global_key[0].private_key_pem : file(pathexpand(var.ssh_private_key_path))
    }
  }

  tags = {
    Name = "${var.prefix}-h${count.index + 1}"
    Creator = var.prefix
  }
}
