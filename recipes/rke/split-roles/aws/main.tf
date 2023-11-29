module "master_nodes" {
  source = "../../../../modules/infra/aws"

  prefix                  = var.prefix
  instance_count          = var.master_nodes_count
  instance_type           = var.master_nodes_instance_type
  instance_disk_size      = var.master_nodes_instance_disk_size
  create_ssh_key_pair     = var.create_ssh_key_pair
  ssh_key_pair_name       = var.ssh_key_pair_name
  ssh_key_pair_path       = var.ssh_key_pair_path
  ssh_username            = var.ssh_username
  aws_region              = var.aws_region
  create_security_group   = var.create_security_group
  instance_security_group = var.instance_security_group
  subnet_id               = var.subnet_id
  user_data = templatefile("${path.module}/user_data.tmpl",
    {
      install_docker = var.install_docker
      username       = var.ssh_username
      docker_version = var.docker_version
    }
  )
}

module "worker_nodes" {
  source = "../../../../modules/infra/aws"

  prefix                  = var.prefix
  instance_count          = var.worker_nodes_count
  instance_type           = var.worker_nodes_instance_type
  instance_disk_size      = var.worker_nodes_instance_disk_size
  create_ssh_key_pair     = var.create_ssh_key_pair
  ssh_key_pair_name       = var.ssh_key_pair_name
  ssh_key_pair_path       = var.ssh_key_pair_path
  ssh_username            = var.ssh_username
  aws_region              = var.aws_region
  create_security_group   = var.create_security_group
  instance_security_group = var.instance_security_group
  subnet_id               = var.subnet_id
  user_data = templatefile("${path.module}/user_data.tmpl",
    {
      install_docker = var.install_docker
      username       = var.ssh_username
      docker_version = var.docker_version
    }
  )
}

locals {
  master_nodes = [for instance_ips in module.master_nodes.instance_ips :
    {
      public_ip  = instance_ips.public_ip,
      private_ip = instance_ips.private_ip,
      roles      = ["etcd", "controlplane"]
    }
  ]
  worker_nodes = [for instance_ips in module.worker_nodes.instance_ips :
    {
      public_ip  = instance_ips.public_ip,
      private_ip = instance_ips.private_ip,
      roles      = ["worker"]
    }
  ]
}

module "rke" {
  source               = "../../../../modules/distribution/rke"
  prefix               = var.prefix
  dependency           = [module.master_nodes.dependency, module.worker_nodes.dependency]
  ssh_private_key_path = module.master_nodes.ssh_key_path
  node_username        = var.ssh_username
  kube_config_path     = var.kube_config_path
  kubernetes_version   = var.kubernetes_version

  rancher_nodes = concat(local.master_nodes, local.worker_nodes)
}
