module "upstream-cluster" {
  source              = "../../../../modules/infra/aws"
  prefix              = var.prefix
  instance_count      = var.instance_count
  instance_type       = var.instance_type
  create_ssh_key_pair = var.create_ssh_key_pair
  ssh_key_pair_name   = var.ssh_key_pair_name
  ssh_key_pair_path   = var.ssh_key_pair_path
  ssh_username        = var.ssh_username
  spot_instances      = var.spot_instances
  aws_region          = var.aws_region
  user_data = templatefile("${path.module}/user_data.sh",
    {
      install_docker = var.install_docker
      username       = var.ssh_username
    }
  )
}

module "rke" {
  source               = "../../../../modules/distribution/rke"
  prefix               = var.prefix
  dependency           = module.upstream-cluster.dependency
  ssh_private_key_path = module.upstream-cluster.ssh_key_path
  node_username        = var.ssh_username
  kube_config_path     = var.kube_config_path
  kubernetes_version   = var.kubernetes_version

  rancher_nodes = [for instance_ips in module.upstream-cluster.instance_ips :
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