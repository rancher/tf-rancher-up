locals {
  new_key_pair_path = var.ssh_private_key_path != null ? var.ssh_private_key_path : "${path.cwd}/${var.prefix}-ssh_private_key.pem"
  existing_subnet   = var.subnet_id != null ? var.subnet_id : try(data.aws_subnets.default_subnets[0].ids, [])
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

resource "aws_key_pair" "key_pair" {
  count      = var.create_ssh_key_pair ? 1 : 0
  key_name   = "tf-rancher-up-${var.prefix}"
  public_key = tls_private_key.ssh_private_key[0].public_key_openssh
}

module "aws_vpc" {
  count           = var.create_vpc == true ? 1 : 0
  source          = "../vpc"
  prefix          = trimsuffix(var.prefix, "-cp")
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  tags            = var.tags
}

resource "random_shuffle" "subnet" {
  input        = try(module.aws_vpc[0].public_subnets, null) != null ? module.aws_vpc[0].public_subnets : tolist(local.existing_subnet)
  result_count = var.instance_count
}

resource "aws_security_group" "sg_allowall" {
  count  = var.create_security_group ? 1 : 0
  vpc_id = var.create_vpc == true ? module.aws_vpc[0].vpc_id : var.create_security_group ? null : data.aws_security_group.sg[0].vpc_id

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
    description = "Allow all inbound HTTP to nodes"
    from_port   = "80"
    to_port     = "80"
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
  count                  = var.instance_count
  ami                    = var.instance_ami != null ? var.instance_ami : var.os_type == "sles" ? data.aws_ssm_parameter.sles.insecure_value : data.aws_ssm_parameter.ubuntu.insecure_value
  instance_type          = var.instance_type
  subnet_id              = tostring(element(random_shuffle.subnet.result, count.index))
  key_name               = var.create_ssh_key_pair ? aws_key_pair.key_pair[0].key_name : var.ssh_key_pair_name
  vpc_security_group_ids = [var.create_security_group ? aws_security_group.sg_allowall[0].id : var.instance_security_group]
  user_data              = var.user_data

  root_block_device {
    volume_size = var.instance_disk_size
  }

  instance_market_options {
    market_type = var.spot_instances ? "spot" : null
  }

  provisioner "remote-exec" {
    inline = flatten([
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'"
    ])

    connection {
      type        = "ssh"
      host        = var.bastion_host == null ? self.public_ip : self.private_ip
      user        = var.ssh_username
      private_key = var.create_ssh_key_pair ? tls_private_key.ssh_private_key[0].private_key_pem : (var.ssh_key_pair_path != null ? file(pathexpand(var.ssh_key_pair_path)) : var.ssh_key)

      bastion_host        = var.bastion_host != null ? var.bastion_host.address : null
      bastion_user        = var.bastion_host != null ? var.bastion_host.user : null
      bastion_private_key = var.bastion_host != null ? (var.bastion_host.ssh_key_path != null ? file(pathexpand(var.bastion_host.ssh_key_path)) : var.bastion_host.ssh_key) : null
    }
  }

  tags = merge(
    {
      Name    = "${var.prefix}-${count.index + var.tag_begin}"
      Creator = var.prefix
    },
    var.tags
  )

  iam_instance_profile = var.iam_instance_profile

  lifecycle {
    ignore_changes = [ami, instance_market_options, user_data, subnet_id, tags]
  }
}