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

module "k3s_first" {
  source      = "../../../../modules/distribution/k3s"
  k3s_token   = var.k3s_token
  k3s_version = var.k3s_version
  k3s_channel = var.k3s_channel
  k3s_config  = var.k3s_config
}

module "k3s_first_server" {
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
  startup_script       = module.k3s_first.k3s_server_user_data
}

module "k3s_additional" {
  source          = "../../../../modules/distribution/k3s"
  k3s_token       = module.k3s_first.k3s_token
  k3s_version     = var.k3s_version
  k3s_channel     = var.k3s_channel
  k3s_config      = var.k3s_config
  first_server_ip = module.k3s_first_server.instances_private_ip[0]
}

module "k3s_additional_servers" {
  source                    = "../../../../modules/infra/azure/virtual-machine"
  depends_on                = [module.k3s_first_server]
  prefix                    = var.prefix
  tag_begin                 = var.tag_begin
  create_rg                 = local.create_rg
  resource_group_location   = module.k3s_first_server.resource_group_location
  resource_group_name       = module.k3s_first_server.resource_group_name
  region                    = var.region
  create_ssh_key_pair       = false
  ssh_private_key_path      = local.local_ssh_private_key_path
  ssh_public_key_path       = local.local_ssh_public_key_path
  create_vnet               = local.create_vnet
  create_subnet             = local.create_subnet
  subnet_id                 = module.k3s_first_server.subnet[0].id
  create_firewall           = local.create_firewall
  network_security_group_id = module.k3s_first_server.network_security_group_id
  instance_count            = var.server_instance_count - 1
  instance_disk_size        = var.instance_disk_size
  disk_type                 = var.disk_type
  instance_type             = var.instance_type
  os_type                   = var.os_type
  spot_instance             = var.spot_instance
  startup_script            = module.k3s_additional.k3s_server_user_data
}

module "k3s_additional_workers" {
  source                    = "../../../../modules/infra/azure/virtual-machine"
  depends_on                = [module.k3s_first_server]
  prefix                    = var.prefix
  tag_begin                 = var.server_instance_count + 1
  create_rg                 = local.create_rg
  resource_group_location   = module.k3s_first_server.resource_group_location
  resource_group_name       = module.k3s_first_server.resource_group_name
  region                    = var.region
  create_ssh_key_pair       = false
  ssh_private_key_path      = local.local_ssh_private_key_path
  ssh_public_key_path       = local.local_ssh_public_key_path
  create_vnet               = local.create_vnet
  create_subnet             = local.create_subnet
  subnet_id                 = module.k3s_first_server.subnet[0].id
  create_firewall           = local.create_firewall
  network_security_group_id = module.k3s_first_server.network_security_group_id
  instance_count            = var.worker_instance_count
  instance_disk_size        = var.instance_disk_size
  disk_type                 = var.disk_type
  instance_type             = var.instance_type
  os_type                   = var.os_type
  spot_instance             = var.spot_instance
  startup_script            = module.k3s_additional.k3s_worker_user_data
}


data "local_file" "ssh_private_key" {
  depends_on = [module.k3s_additional_servers, module.k3s_additional_workers]
  filename   = local.local_ssh_private_key_path
}

resource "ssh_resource" "retrieve_kubeconfig" {
  depends_on = [data.local_file.ssh_private_key]
  host       = module.k3s_first_server.instances_public_ip[0]
  commands = [
    "sudo sed 's/127.0.0.1/${module.k3s_first_server.instances_public_ip[0]}/g' /etc/rancher/k3s/k3s.yaml"
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

module "rancher_install" {
  source                     = "../../../../modules/rancher"
  dependency                 = [module.k3s_additional_servers, module.k3s_additional_workers]
  kubeconfig_file            = local_file.kube_config_yaml.filename
  rancher_hostname           = join(".", [var.rancher_hostname, module.k3s_first_server.instances_public_ip[0], "sslip.io"])
  rancher_bootstrap_password = var.rancher_bootstrap_password
  rancher_password           = var.rancher_password
  bootstrap_rancher          = var.bootstrap_rancher
  rancher_version            = var.rancher_version
  rancher_additional_helm_values = [
    "replicas: ${var.worker_instance_count}",
    "ingress.ingressClassName: ${var.rancher_ingress_class_name}",
    "service.type: ${var.rancher_service_type}"
  ]
}