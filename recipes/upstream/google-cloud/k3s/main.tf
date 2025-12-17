locals {
  create_ssh_key_pair        = var.create_ssh_key_pair == true ? false : true
  local_ssh_private_key_path = var.ssh_private_key_path == null ? "${path.cwd}/${var.prefix}-ssh_private_key.pem" : var.ssh_private_key_path
  local_ssh_public_key_path  = var.ssh_public_key_path == null ? "${path.cwd}/${var.prefix}-ssh_public_key.pem" : var.ssh_public_key_path
  create_vpc                 = var.create_vpc == true ? false : var.create_vpc
  vpc                        = var.vpc == null ? module.k3s_first_server.vpc[0].name : var.vpc
  subnet                     = var.subnet == null ? module.k3s_first_server.subnet[0].name : var.subnet
  create_firewall            = var.create_firewall == true ? false : var.create_firewall
  ssh_username               = var.os_type
  kc_path                    = var.kube_config_path != null ? var.kube_config_path : path.cwd
  kc_file                    = var.kube_config_filename != null ? "${local.kc_path}/${var.kube_config_filename}" : "${local.kc_path}/${var.prefix}_kube_config.yml"
  rancher_replicas           = var.server_instance_count + var.worker_instance_count
}

module "k3s_first" {
  source      = "../../../../modules/distribution/k3s"
  k3s_token   = var.k3s_token
  k3s_version = var.k3s_version
  k3s_channel = var.k3s_channel
  k3s_config  = var.k3s_config
}

module "k3s_first_server" {
  source               = "../../../../modules/infra/google-cloud/compute-engine"
  prefix               = var.prefix
  project_id           = var.project_id
  region               = var.region
  create_ssh_key_pair  = var.create_ssh_key_pair
  ssh_private_key_path = local.local_ssh_private_key_path
  ssh_public_key_path  = local.local_ssh_public_key_path
  create_vpc           = var.create_vpc
  vpc                  = var.vpc
  subnet               = var.subnet
  create_firewall      = var.create_firewall
  instance_count       = 1
  instance_disk_size   = var.instance_disk_size
  disk_type            = var.disk_type
  instance_type        = var.instance_type
  os_type              = var.os_type
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
  source               = "../../../../modules/infra/google-cloud/compute-engine"
  prefix               = var.prefix
  project_id           = var.project_id
  region               = var.region
  create_ssh_key_pair  = local.create_ssh_key_pair
  ssh_private_key_path = local.local_ssh_private_key_path
  ssh_public_key_path  = module.k3s_first_server.public_ssh_key
  create_vpc           = local.create_vpc
  vpc                  = local.vpc
  subnet               = local.subnet
  create_firewall      = local.create_firewall
  instance_count       = var.server_instance_count - 1
  instance_disk_size   = var.instance_disk_size
  disk_type            = var.disk_type
  instance_type        = var.instance_type
  os_type              = var.os_type
  startup_script       = module.k3s_additional.k3s_server_user_data
}

module "k3s_additional_workers" {
  source               = "../../../../modules/infra/google-cloud/compute-engine"
  prefix               = var.prefix
  project_id           = var.project_id
  region               = var.region
  create_ssh_key_pair  = local.create_ssh_key_pair
  ssh_private_key_path = local.local_ssh_private_key_path
  ssh_public_key_path  = module.k3s_first_server.public_ssh_key
  create_vpc           = local.create_vpc
  vpc                  = local.vpc
  subnet               = local.subnet
  create_firewall      = local.create_firewall
  instance_count       = var.worker_instance_count
  instance_disk_size   = var.instance_disk_size
  disk_type            = var.disk_type
  instance_type        = var.instance_type
  os_type              = var.os_type
  startup_script       = module.k3s_additional.k3s_worker_user_data
}

data "local_file" "ssh_private_key" {
  depends_on = [module.k3s_additional_workers]

  filename = local.local_ssh_private_key_path
}

resource "ssh_resource" "retrieve_kubeconfig" {
  depends_on = [data.local_file.ssh_private_key]

  host = module.k3s_first_server.instances_public_ip[0]
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

resource "null_resource" "wait_k8s_services_startup" {
  depends_on = [local_file.kube_config_yaml]

  provisioner "local-exec" {
    command = "sleep ${var.waiting_time}"
  }
}

locals {
  rancher_hostname = var.rancher_hostname != null ? join(".", ["${var.rancher_hostname}", module.k3s_first_server.instances_public_ip[0], "sslip.io"]) : join(".", ["rancher", module.k3s_first_server.instances_public_ip[0], "sslip.io"])
}

module "rancher_install" {
  source                     = "../../../../modules/rancher"
  dependency                 = [module.k3s_first_server, null_resource.wait_k8s_services_startup]
  kubeconfig_file            = local_file.kube_config_yaml.filename
  rancher_hostname           = local.rancher_hostname
  rancher_bootstrap_password = var.rancher_bootstrap_password
  rancher_password           = var.rancher_password
  bootstrap_rancher          = var.bootstrap_rancher
  rancher_version            = var.rancher_version
  rancher_replicas           = min(var.rancher_replicas, local.rancher_replicas)
  rancher_additional_helm_values = [
    "replicas: ${var.worker_instance_count}",
    "ingress.ingressClassName: ${var.rancher_ingress_class_name}",
    "service.type: ${var.rancher_service_type}"
  ]
}
