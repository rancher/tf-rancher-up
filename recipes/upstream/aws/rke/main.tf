provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region = var.aws_region
}

module "upstream-cluster" {
  source = "../../modules/infra/aws"
  providers = {
    aws = aws
  }

  prefix = var.prefix
  instance_count = var.instance_count
  instance_ssh_key_name = var.instance_ssh_key_name
  ssh_private_key_path = var.ssh_private_key_path
  #  should_create_security_group = false
}

module "rke" {
  source = "../../modules/distribution/rke-module"
  depends_on = [module.upstream-cluster]

  node_username = "ubuntu"
  ssh_private_key_path = var.ssh_private_key_path

  rancher_nodes = [for instance_ips in module.upstream-cluster.instances_ips:
    {
      public_ip = instance_ips.public_ip,
      private_ip = ""
#      private_ip = instance_ips.private_ip,
      roles = ["etcd", "controlplane", "worker"]
    }
  ]
}

provider "helm" {
  kubernetes {
    config_path = "${path.module}/${module.rke.rke_kubeconfig_filename}"
  }
}

provider "kubernetes" {
  config_path = "${path.module}/${module.rke.rke_kubeconfig_filename}"
  insecure    = true
}

module "rancher_install" {
  source = "../../modules/rancher"
  depends_on = [module.rke]

  rancher_hostname = join(".", ["rancher", module.upstream-cluster.instances_public_ip[0], "sslip.io"])
  rancher_replicas  = 1
  rancher_bootstrap_password = "changeme"

  providers = {
    kubernetes = kubernetes
    helm = helm
  }
}
