module "upstream-cluster" {
  source              = "../../../../modules/infra/aws"
  prefix              = var.prefix
  instance_count      = var.instance_count
  create_ssh_key_pair = var.create_ssh_key_pair
  ssh_key_pair_name   = var.ssh_key_pair_name
  ssh_key_pair_path   = var.ssh_key_pair_path
  spot_instances      = var.spot_instances
  aws_region          = var.aws_region
}

module "rke" {
  source               = "../../../../modules/distribution/rke"
  prefix               = var.prefix
  dependency           = module.upstream-cluster.dependency
  ssh_private_key_path = module.upstream-cluster.ssh_key_path
  kube_config_path     = var.kube_config_path
  kubernetes_version   = var.kubernetes_version

  rancher_nodes = [for instance_ips in module.upstream-cluster.instances_ips :
    {
      public_ip  = instance_ips.public_ip,
      private_ip = instance_ips.private_ip,
      roles      = ["etcd", "controlplane", "worker"]
    }
  ]
}

module "rancher_install" {
  source                     = "../../../../modules/rancher"
  dependency                 = module.rke.dependency
  kubeconfig_file            = module.rke.rke_kubeconfig_filename
  rancher_hostname           = join(".", ["rancher", module.upstream-cluster.instances_public_ip[0], "sslip.io"])
  rancher_replicas           = var.instance_count
  rancher_bootstrap_password = var.rancher_password
  rancher_version            = var.rancher_version
}