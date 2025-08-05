locals {
  rke2_installation     = true
  kc_path               = var.kube_config_path != null ? var.kube_config_path : path.cwd
  kc_file               = var.kube_config_filename != null ? "${local.kc_path}/${var.kube_config_filename}" : "${local.kc_path}/${var.prefix}_kube_config.yml"
  first_node_droplet_id = module.rke2_first_server.droplet_ids
}

module "rke2_first" {
  source       = "../../../../modules/distribution/rke2"
  rke2_token   = var.rke2_token
  rke2_version = var.rke2_version
  rke2_config  = var.rke2_config
}

module "rke2_first_server" {
  source                      = "../../../../modules/infra/digitalocean/"
  prefix                      = var.prefix
  do_token                    = var.do_token
  droplet_count               = 1
  droplet_size                = var.droplet_size
  ssh_key_pair_name           = var.ssh_key_pair_name
  ssh_key_pair_path           = var.ssh_key_pair_path
  region                      = var.region
  create_ssh_key_pair         = var.create_ssh_key_pair
  ssh_private_key_path        = var.ssh_private_key_path
  user_data                   = module.rke2_first.rke2_user_data
  create_firewall             = false
  create_https_loadbalancer   = false
  create_k8s_api_loadbalancer = false
  droplet_image               = var.droplet_image
  os_type                     = var.os_type
  rke2_installation           = local.rke2_installation
}

module "rke2_additional" {
  source          = "../../../../modules/distribution/rke2"
  rke2_token      = module.rke2_first.rke2_token
  rke2_version    = var.rke2_version
  rke2_config     = var.rke2_config
  first_server_ip = module.rke2_first_server.droplets_public_ip[0]
}

module "rke2_additional_servers" {
  source                      = "../../../../modules/infra/digitalocean/"
  depends_on                  = [module.rke2_first_server]
  prefix                      = var.prefix
  do_token                    = var.do_token
  droplet_count               = var.droplet_count - 1
  droplet_size                = var.droplet_size
  tag_begin                   = var.tag_begin
  ssh_key_pair_name           = var.ssh_key_pair_name
  ssh_key_pair_path           = var.ssh_key_pair_path
  region                      = var.region
  create_ssh_key_pair         = false
  ssh_private_key_path        = var.ssh_private_key_path
  user_data                   = module.rke2_additional.rke2_user_data
  create_firewall             = var.create_firewall
  create_https_loadbalancer   = var.create_https_loadbalancer
  create_k8s_api_loadbalancer = var.create_k8s_api_loadbalancer
  extra_droplet_id            = local.first_node_droplet_id
  droplet_image               = var.droplet_image
  os_type                     = var.os_type
  rke2_installation           = local.rke2_installation
}

data "local_file" "ssh_private_key" {
  depends_on = [module.rke2_additional_servers]
  filename   = module.rke2_first_server.ssh_key_path
}

resource "ssh_resource" "retrieve_kubeconfig" {
  depends_on = [module.rke2_additional_servers]

  host = module.rke2_first_server.droplets_public_ip[0]
  commands = [
    "sudo sed 's/127.0.0.1/${module.rke2_first_server.droplets_public_ip[0]}/g' /etc/rancher/rke2/rke2.yaml"
  ]
  user        = var.ssh_username
  private_key = data.local_file.ssh_private_key.content
}

resource "local_file" "kube_config_yaml" {
  filename        = pathexpand(local.kc_file)
  content         = ssh_resource.retrieve_kubeconfig.result
  file_permission = "0600"
}

provider "kubernetes" {
  config_path = local_file.kube_config_yaml.filename
}

provider "helm" {
  kubernetes {
    config_path = local_file.kube_config_yaml.filename
  }
}

locals {
  rancher_hostname = var.rancher_hostname != null ? join(".", ["${var.rancher_hostname}", module.rke2_first_server.droplets_public_ip[0], "sslip.io"]) : join(".", ["rancher", module.rke2_first_server.droplets_public_ip[0], "sslip.io"])
}

module "rancher_install" {
  source                     = "../../../../modules/rancher"
  dependency                 = var.droplet_count > 1 ? module.rke2_additional_servers.dependency : module.rke2_first_server.dependency
  kubeconfig_file            = local_file.kube_config_yaml.filename
  rancher_hostname           = local.rancher_hostname
  rancher_bootstrap_password = var.rancher_bootstrap_password
  rancher_password           = var.rancher_password
  bootstrap_rancher          = var.bootstrap_rancher
  rancher_version            = var.rancher_version
  rancher_additional_helm_values = [
    "replicas: ${var.droplet_count}",
    "ingress.ingressClassName: ${var.rancher_ingress_class_name}",
    "service.type: ${var.rancher_service_type}"
  ]
}
