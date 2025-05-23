locals {
  rancher_hostname = var.create_https_loadbalancer ? module.upstream-cluster.https_loadbalancer_ip : module.upstream-cluster.droplets_public_ip[0]
  startup_script   = var.os_type == "ubuntu" ? templatefile("${path.module}/cloud-config.yaml", {}) : "#!/bin/bash\nzypper --non-interactive install docker && sudo systemctl enable --now docker"
  kc_path          = var.kube_config_path != null ? var.kube_config_path : path.cwd
  kc_file          = var.kube_config_filename != null ? basename(var.kube_config_filename) : "${var.prefix}_kube_config.yml"
}

module "upstream-cluster" {
  source                      = "../../../../modules/infra/digitalocean"
  prefix                      = var.prefix
  do_token                    = var.do_token
  droplet_count               = var.droplet_count
  droplet_size                = var.droplet_size
  ssh_key_pair_name           = var.ssh_key_pair_name
  ssh_key_pair_path           = var.ssh_key_pair_path
  region                      = var.region
  create_ssh_key_pair         = var.create_ssh_key_pair
  ssh_private_key_path        = var.ssh_private_key_path
  user_data                   = local.startup_script
  create_https_loadbalancer   = var.create_https_loadbalancer
  create_k8s_api_loadbalancer = var.create_k8s_api_loadbalancer
  droplet_image               = var.droplet_image
  os_type                     = var.os_type
}

module "rke" {
  source               = "../../../../modules/distribution/rke"
  prefix               = var.prefix
  dependency           = module.upstream-cluster.dependency
  ssh_private_key_path = pathexpand(module.upstream-cluster.ssh_key_path)
  node_username        = var.ssh_username
  kube_config_path     = local.kc_path
  kube_config_filename = local.kc_file
  kubernetes_version   = var.kubernetes_version
  additional_hostnames = [module.upstream-cluster.k8s_api_loadbalancer_ip]

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

resource "null_resource" "wait-k8s-services-startup" {
  depends_on = [module.rke]

  provisioner "local-exec" {
    command = "sleep ${var.waiting_time}"
  }
}

module "rancher_install" {
  source                           = "../../../../modules/rancher"
  dependency                       = [module.upstream-cluster, null_resource.wait-k8s-services-startup]
  kubeconfig_file                  = module.rke.rke_kubeconfig_filename
  rancher_hostname                 = join(".", ["rancher", local.rancher_hostname, "sslip.io"])
  rancher_replicas                 = var.droplet_count
  rancher_bootstrap_password       = var.rancher_bootstrap_password
  rancher_password                 = var.rancher_password
  rancher_version                  = var.rancher_version
  rancher_helm_repository          = var.rancher_helm_repository
  rancher_helm_repository_username = var.rancher_helm_repository_username
  rancher_helm_repository_password = var.rancher_helm_repository_password
  wait                             = var.wait
}