provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

module "upstream-cluster" {
  source = "../../../../modules/infra/aws"
  providers = {
    aws = aws
  }

  prefix         = var.prefix
  instance_count = var.instance_count
 # instance_ssh_key_name = var.instance_ssh_key_name
  ssh_private_key_path = var.ssh_private_key_path 
 # create_ssh_key_pair = var.create_ssh_key_pair
 # ssh_key_pair_name   = var.ssh_key_pair_name
 # ssh_key_pair_path   = var.ssh_key_pair_path
}

module "rke2" {
  source               = "../../../../modules/distribution/rke2"
  dependency           = module.upstream-cluster.dependency
  ssh_private_key_path = module.upstream-cluster.ssh_key_path
  node_username        = var.node_username

  rancher_nodes = [for instance_ips in module.upstream-cluster.instances_ips :
    {
      public_ip  = instance_ips.public_ip,
      private_ip = instance_ips.private_ip,
    }
  ]
}

module "rancher_install" {
  source                     = "../../../../modules/rancher"
  dependency                 = module.rke2.dependency
  kubeconfig_file            = module.rke2.rke2_kubeconfig_filename
  rancher_hostname           = join(".", ["rancher", module.upstream-cluster.instances_public_ip[0], "sslip.io"])
  rancher_replicas           = var.instance_count
  rancher_bootstrap_password = "Admin123456789"
  rancher_version            = var.rancher_version
}
