locals {
  create_ssh_key_pair        = var.create_ssh_key_pair == null ? false : true
  ssh_key_pair_name          = var.ssh_key_pair_name == null ? "tf-rancher-up-${var.prefix}" : var.ssh_key_pair_name
  local_ssh_private_key_path = var.ssh_private_key_path == null ? "${path.cwd}/${var.prefix}-ssh_private_key.pem" : var.ssh_private_key_path
  local_ssh_public_key_path  = var.ssh_public_key_path == null ? "${path.cwd}/${var.prefix}-ssh_public_key.pem" : var.ssh_public_key_path
  create_vpc                 = var.create_vpc == null ? false : true
  kc_path                    = var.kube_config_path != null ? var.kube_config_path : path.cwd
  kc_file                    = var.kube_config_filename != null ? "${local.kc_path}/${var.kube_config_filename}" : "${local.kc_path}/${var.prefix}_kube_config.yml"
}

module "aws_ec2_upstream_cluster" {
  source                     = "../../../../modules/infra/aws/ec2"
  prefix                     = var.prefix
  aws_region                 = var.aws_region
  create_ssh_key_pair        = var.create_ssh_key_pair
  ssh_key_pair_name          = local.ssh_key_pair_name
  ssh_private_key_path       = local.local_ssh_private_key_path
  ssh_public_key_path        = local.local_ssh_public_key_path
  create_vpc                 = var.create_vpc
  vpc_id                     = var.vpc_id
  subnet_id                  = var.subnet_id
  create_security_group      = var.create_security_group
  instance_count             = var.instance_count
  instance_type              = var.instance_type
  spot_instances             = var.spot_instances
  instance_disk_size         = var.instance_disk_size
  instance_security_group_id = var.instance_security_group_id
  ssh_username               = var.ssh_username
  user_data = templatefile("${path.module}/user_data.tmpl",
    {
      install_docker = var.install_docker
      username       = var.ssh_username
      docker_version = var.docker_version
    }
  )
  bastion_host         = var.bastion_host
  iam_instance_profile = var.iam_instance_profile
  tags                 = var.tags
}

resource "null_resource" "wait_docker_startup" {
  depends_on = [module.aws_ec2_upstream_cluster.instances_public_ip]
  provisioner "local-exec" {
    command = "sleep ${var.waiting_time}"
  }
}

module "rke" {
  source               = "../../../../modules/distribution/rke"
  prefix               = var.prefix
  dependency           = [null_resource.wait_docker_startup]
  ssh_private_key_path = local.local_ssh_private_key_path
  node_username        = var.ssh_username
  kubernetes_version   = var.kubernetes_version

  rancher_nodes = [for instance_ips in module.aws_ec2_upstream_cluster.instance_ips :
    {
      public_ip         = instance_ips.public_ip,
      private_ip        = instance_ips.private_ip,
      roles             = ["etcd", "controlplane", "worker"],
      ssh_key_path      = local.local_ssh_private_key_path,
      ssh_key           = null,
      hostname_override = null
    }
  ]
}

resource "null_resource" "wait_k8s_services_startup" {
  depends_on = [module.rke]
  provisioner "local-exec" {
    command = "sleep ${var.waiting_time}"
  }
}
