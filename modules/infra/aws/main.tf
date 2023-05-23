# Condition to use an existing keypair if a keypair file is also provided
locals {
  use_existing_key_pair = var.ssh_key_pair_name != null && var.ssh_key_pair_path != null ? true : false
  create_new_key_pair   = var.create_ssh_key_pair || !local.use_existing_key_pair ? true : false
  new_key_pair_path     = var.ssh_private_key_path != null ? var.ssh_private_key_path : "${path.cwd}/${var.prefix}-ssh_private_key.pem"
}

data "aws_subnet" "subnet" {
  count = var.subnet_id != null ? 1 : 0
  id    = var.subnet_id
}

resource "tls_private_key" "ssh_private_key" {
  count     = local.create_new_key_pair ? 1 : 0
  algorithm = "ED25519"
}

resource "local_file" "private_key_pem" {
  count           = local.create_new_key_pair ? 1 : 0
  filename        = local.new_key_pair_path
  content         = tls_private_key.ssh_private_key[0].private_key_openssh
  file_permission = "0400"
}

resource "aws_key_pair" "key_pair" {
  count           = local.create_new_key_pair ? 1 : 0
  key_name_prefix = "${var.prefix}-"
  public_key      = tls_private_key.ssh_private_key[0].public_key_openssh
}

resource "aws_security_group" "sg_allowall" {
  count  = var.create_security_group ? 1 : 0
  vpc_id = var.subnet_id != null ? data.aws_subnet.subnet[0].vpc_id : null

  name        = "${var.prefix}-allow-nodes"
  description = "Allow traffic for nodes in the cluster"

  ingress {
    description = "Allow all inbound from nodes in the cluster"
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    self        = true
  }

  ingress {
    description = "Allow all inbound SSH to nodes"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow all inbound kube-apiserver to nodes"
    from_port   = "6443"
    to_port     = "6443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow all inbound HTTPS to nodes"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
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
  count         = var.instance_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id

  key_name        = local.create_new_key_pair ? aws_key_pair.key_pair[0].key_name : var.ssh_key_pair_name
  security_groups = [var.create_security_group ? aws_security_group.sg_allowall[0].name : var.instance_security_group]

  root_block_device {
    volume_size = var.instance_disk_size
  }

  user_data = templatefile("${path.module}/user_data.sh",
    {
      install_docker = var.install_docker
      username       = var.ssh_username
    }
  )

  provisioner "remote-exec" {
    inline = flatten([
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'"
    ])

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = var.ssh_username
      private_key = local.create_new_key_pair ? tls_private_key.ssh_private_key[0].private_key_pem : file(pathexpand(var.ssh_key_pair_path))
    }
  }

  tags = {
    Name    = "${var.prefix}-${count.index + 1}"
    Creator = var.prefix
  }
}