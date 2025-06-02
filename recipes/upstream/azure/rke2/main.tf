locals {
  create_ssh_key_pair        = var.create_ssh_key_pair == true ? false : true
  local_ssh_private_key_path = var.ssh_private_key_path == null ? "${path.cwd}/${var.prefix}-ssh_private_key.pem" : var.ssh_private_key_path
  local_ssh_public_key_path  = var.ssh_public_key_path == null ? "${path.cwd}/${var.prefix}-ssh_public_key.pem" : var.ssh_public_key_path
  create_rg                  = var.create_rg == true ? false : var.create_rg
  create_vnet                = var.create_vnet == true ? false : var.create_vnet
  create_subnet              = var.create_subnet == true ? false : var.create_subnet
  create_firewall            = var.create_firewall == true ? false : var.create_firewall
  ssh_username               = var.os_type
  kc_path                    = var.kube_config_path != null ? var.kube_config_path : path.cwd
  kc_file                    = var.kube_config_filename != null ? "${local.kc_path}/${var.kube_config_filename}" : "${local.kc_path}/${var.prefix}_kube_config.yml"
}

module "rke2_first" {
  source       = "../../../../modules/distribution/rke2"
  rke2_token   = var.rke2_token
  rke2_version = var.rke2_version
  rke2_config  = var.rke2_config
}

module "rke2_first_server" {
  source               = "../../../../modules/infra/azure/virtual-machine"
  prefix               = var.prefix
  create_rg            = var.create_rg
  region               = var.region
  create_ssh_key_pair  = var.create_ssh_key_pair
  ssh_private_key_path = local.local_ssh_private_key_path
  ssh_public_key_path  = local.local_ssh_public_key_path
  create_vnet          = var.create_vnet
  create_subnet        = var.create_subnet
  create_firewall      = var.create_firewall
  instance_count       = 1
  instance_disk_size   = var.instance_disk_size
  disk_type            = var.disk_type
  instance_type        = var.instance_type
  os_type              = var.os_type
  spot_instance        = var.spot_instance
  startup_script       = module.rke2_first.rke2_user_data
}

module "rke2_additional" {
  source          = "../../../../modules/distribution/rke2"
  rke2_token      = module.rke2_first.rke2_token
  rke2_version    = var.rke2_version
  rke2_config     = var.rke2_config
  first_server_ip = module.rke2_first_server.instances_private_ip[0]
}

module "rke2_additional_servers" {
  source                    = "../../../../modules/infra/azure/virtual-machine"
  depends_on                = [module.rke2_first_server]
  prefix                    = var.prefix
  tag_begin                 = var.tag_begin
  create_rg                 = local.create_rg
  resource_group_location   = module.rke2_first_server.resource_group_location
  resource_group_name       = module.rke2_first_server.resource_group_name
  region                    = var.region
  create_ssh_key_pair       = false
  ssh_private_key_path      = local.local_ssh_private_key_path
  ssh_public_key_path       = local.local_ssh_public_key_path
  create_vnet               = local.create_vnet
  create_subnet             = local.create_subnet
  subnet_id                 = module.rke2_first_server.subnet[0].id
  create_firewall           = local.create_firewall
  network_security_group_id = module.rke2_first_server.network_security_group_id
  instance_count            = var.instance_count - 1
  instance_disk_size        = var.instance_disk_size
  disk_type                 = var.disk_type
  instance_type             = var.instance_type
  os_type                   = var.os_type
  spot_instance             = var.spot_instance
  startup_script            = module.rke2_additional.rke2_user_data
}

data "local_file" "ssh_private_key" {
  depends_on = [module.rke2_additional_servers]
  filename   = local.local_ssh_private_key_path
}

resource "ssh_resource" "retrieve_kubeconfig" {
  depends_on = [data.local_file.ssh_private_key]

  host = module.rke2_first_server.instances_public_ip[0]
  commands = [
    "sudo sed 's/127.0.0.1/${module.rke2_first_server.instances_public_ip[0]}/g' /etc/rancher/rke2/rke2.yaml"
  ]
  user        = local.ssh_username
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
  rancher_hostname = var.rancher_hostname != null ? join(".", ["${var.rancher_hostname}", module.rke2_first_server.instances_public_ip[0], "sslip.io"]) : join(".", ["rancher", module.rke2_first_server.instances_public_ip[0], "sslip.io"])
}

module "rancher_install" {
  source                     = "../../../../modules/rancher"
  dependency                 = [module.rke2_first_server]
  kubeconfig_file            = local_file.kube_config_yaml.filename
  rancher_hostname           = local.rancher_hostname
  rancher_bootstrap_password = var.rancher_bootstrap_password
  rancher_password           = var.rancher_password
  bootstrap_rancher          = var.bootstrap_rancher
  rancher_version            = var.rancher_version
  rancher_additional_helm_values = [
    "replicas: ${var.instance_count}",
    "ingress.ingressClassName: ${var.rancher_ingress_class_name}",
    "service.type: ${var.rancher_service_type}"
  ]
}
