locals {
  create_ssh_key_pair        = var.create_ssh_key_pair == null ? false : true
  ssh_key_pair_name          = var.ssh_key_pair_name == null ? "tf-rancher-up-${var.prefix}" : var.ssh_key_pair_name
  local_ssh_private_key_path = var.ssh_private_key_path == null ? "${path.cwd}/${var.prefix}-ssh_private_key.pem" : var.ssh_private_key_path
  local_ssh_public_key_path  = var.ssh_public_key_path == null ? "${path.cwd}/${var.prefix}-ssh_public_key.pem" : var.ssh_public_key_path
  create_vpc                 = var.create_vpc == null ? false : true
  vpc_id                     = var.vpc_id == null ? module.aws-ec2-upstream-master-nodes.vpc[0].id : var.vpc_id
  subnet_id                  = var.subnet_id == null ? module.aws-ec2-upstream-master-nodes.subnet[0].id : var.subnet_id
  create_security_group      = var.create_security_group == null ? false : true
  instance_security_group_id = local.create_security_group == "true" ? null : module.aws-ec2-upstream-master-nodes.security_group[0].id
}

module "aws-ec2-upstream-master-nodes" {
  source         = "../../../../modules/infra/aws/ec2"
  prefix         = var.prefix
  aws_region     = var.aws_region
  instance_count = var.server_nodes_count
  ssh_username   = var.ssh_username
  user_data = templatefile("${path.module}/user_data.tmpl",
    {
      install_docker = var.install_docker
      username       = var.ssh_username
      docker_version = var.docker_version
    }
  )
}

module "aws-ec2-upstream-worker-nodes" {
  source                     = "../../../../modules/infra/aws/ec2"
  prefix                     = "${var.prefix}-w"
  aws_region                 = var.aws_region
  create_ssh_key_pair        = local.create_ssh_key_pair
  ssh_key_pair_name          = local.ssh_key_pair_name
  ssh_private_key_path       = local.local_ssh_private_key_path
  ssh_public_key_path        = local.local_ssh_public_key_path
  create_vpc                 = local.create_vpc
  vpc_id                     = local.vpc_id
  subnet_id                  = local.subnet_id
  create_security_group      = local.create_security_group
  instance_count             = var.worker_nodes_count
  instance_security_group_id = local.instance_security_group_id
  ssh_username               = var.ssh_username
  user_data = templatefile("${path.module}/user_data.tmpl",
    {
      install_docker = var.install_docker
      username       = var.ssh_username
      docker_version = var.docker_version
    }
  )
}

resource "null_resource" "wait-docker-startup-m" {
  depends_on = [module.aws-ec2-upstream-master-nodes.instances_public_ip]
  provisioner "local-exec" {
    command = "sleep ${var.waiting_time}"
  }
}

resource "null_resource" "wait-docker-startup-w" {
  depends_on = [module.aws-ec2-upstream-worker-nodes.instances_public_ip]
  provisioner "local-exec" {
    command = "sleep ${var.waiting_time}"
  }
}

locals {
  ssh_private_key_path = var.ssh_private_key_path != null ? var.ssh_private_key_path : "${path.cwd}/${var.prefix}-ssh_private_key.pem"
  server_nodes = [for instance_ips in module.aws-ec2-upstream-master-nodes.instance_ips :
    {
      public_ip         = instance_ips.public_ip,
      private_ip        = instance_ips.private_ip,
      roles             = ["etcd", "controlplane"],
      ssh_key_path      = local.ssh_private_key_path,
      ssh_key           = null,
      hostname_override = null
    }
  ]
  worker_nodes = [for instance_ips in module.aws-ec2-upstream-worker-nodes.instance_ips :
    {
      public_ip         = instance_ips.public_ip,
      private_ip        = instance_ips.private_ip,
      roles             = ["worker"],
      ssh_key_path      = local.ssh_private_key_path,
      ssh_key           = null,
      hostname_override = null
    }
  ]
}

module "rke" {
  source               = "../../../../modules/distribution/rke"
  prefix               = var.prefix
  ssh_private_key_path = local.ssh_private_key_path
  node_username        = var.ssh_username
  ingress_provider     = var.ingress_provider

  rancher_nodes = concat(local.server_nodes, local.worker_nodes)
}

resource "null_resource" "wait-k8s-services-startup" {
  depends_on = [module.rke]
  provisioner "local-exec" {
    command = "sleep ${var.waiting_time}"
  }
}

locals {
  kubeconfig_file  = "${path.cwd}/${var.prefix}_kube_config.yml"
  rancher_hostname = var.rancher_hostname != null ? join(".", ["${var.rancher_hostname}", module.aws-ec2-upstream-worker-nodes.instances_public_ip[0], "sslip.io"]) : join(".", ["rancher", module.aws-ec2-upstream-worker-nodes.instances_public_ip[0], "sslip.io"])
}

module "rancher_install" {
  source                     = "../../../../modules/rancher"
  dependency                 = [null_resource.wait-k8s-services-startup]
  kubeconfig_file            = local.kubeconfig_file
  rancher_hostname           = local.rancher_hostname
  rancher_bootstrap_password = var.rancher_password
  rancher_password           = var.rancher_password
  bootstrap_rancher          = var.bootstrap_rancher
  rancher_version            = var.rancher_version
  rancher_additional_helm_values = [
    "replicas: ${var.worker_nodes_count}"
  ]
}
