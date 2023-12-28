module "upstream-cluster" {
  source               = "../../../../modules/infra/digitalocean"
  prefix               = var.prefix
  do_token             = var.do_token
  droplet_count        = var.droplet_count
  droplet_size         = var.droplet_size
  user_tag             = var.user_tag
  ssh_key_pair_name    = var.ssh_key_pair_name
  ssh_key_pair_path    = var.ssh_key_pair_path
  region               = var.region
  create_ssh_key_pair  = var.create_ssh_key_pair
  ssh_private_key_path = var.ssh_private_key_path
  user_data = templatefile("${path.module}/cloud-config.yaml",
  {})
}

module "rke" {
  source               = "../../../../modules/distribution/rke"
  prefix               = var.prefix
  dependency           = module.upstream-cluster.dependency
  ssh_private_key_path = pathexpand(module.upstream-cluster.ssh_key_path)
  node_username        = var.ssh_username
  kube_config_path     = pathexpand(var.kube_config_path)
  kube_config_filename = var.kube_config_filename
  kubernetes_version   = var.kubernetes_version

  rancher_nodes = [for droplet_ips in module.upstream-cluster.droplet_ips :
    {
      public_ip         = droplet_ips.public_ip,
      private_ip        = droplet_ips.private_ip,
      roles             = ["etcd", "controlplane", "worker"]
      ssh_key_path      = module.upstream-cluster.ssh_key_path
      ssh_key           = null
      hostname_override = null
    }
  ]
}

module "rancher_install" {
  source                     = "../../../../modules/rancher"
  dependency                 = module.rke.dependency
  kubeconfig_file            = module.rke.rke_kubeconfig_filename
  rancher_hostname           = join(".", ["rancher", module.upstream-cluster.droplets_public_ip[0], "sslip.io"])
  rancher_replicas           = var.droplet_count
  rancher_bootstrap_password = var.rancher_password
  rancher_password           = var.rancher_password
  rancher_version            = var.rancher_version
  wait                       = var.wait
}
