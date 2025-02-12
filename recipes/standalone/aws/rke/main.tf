locals {
  ssh_username = var.instance_ami != null ? var.ssh_username : var.os_type == "sles" ? "ec2-user" : "ubuntu"
}

module "cluster-nodes" {
  source                  = "../../../../modules/infra/aws/ec2"
  prefix                  = var.prefix
  instance_count          = var.instance_count
  instance_type           = var.instance_type
  instance_disk_size      = var.instance_disk_size
  instance_ami            = var.instance_ami
  os_type                 = var.os_type
  sles_version            = var.sles_version
  ubuntu_version          = var.ubuntu_version
  create_ssh_key_pair     = var.create_ssh_key_pair
  ssh_key_pair_name       = var.ssh_key_pair_name
  ssh_key_pair_path       = var.ssh_key_pair_path
  ssh_username            = local.ssh_username
  spot_instances          = var.spot_instances
  aws_region              = var.aws_region
  create_security_group   = var.create_security_group
  instance_security_group = var.instance_security_group
  subnet_id               = var.subnet_id
  aws_access_key          = var.aws_access_key
  aws_secret_key          = var.aws_secret_key
  user_data = templatefile("${path.module}/user_data.tmpl",
    {
      install_docker = var.install_docker
      username       = local.ssh_username
      docker_version = var.docker_version
    }
  )
}

module "rke" {
  source               = "../../../../modules/distribution/rke"
  prefix               = var.prefix
  dependency           = module.cluster-nodes.dependency
  ssh_private_key_path = module.cluster-nodes.ssh_key_path
  node_username        = local.ssh_username
  kube_config_path     = var.kube_config_path
  kube_config_filename = var.kube_config_filename
  kubernetes_version   = var.kubernetes_version

  rancher_nodes = [for instance_ips in module.cluster-nodes.instance_ips :
    {
      public_ip         = instance_ips.public_ip,
      private_ip        = instance_ips.private_ip,
      roles             = ["etcd", "controlplane", "worker"],
      ssh_key_path      = module.cluster-nodes.ssh_key_path
      ssh_key           = null
      node_username     = module.cluster-nodes.node_username
      hostname_override = null
    }
  ]
}