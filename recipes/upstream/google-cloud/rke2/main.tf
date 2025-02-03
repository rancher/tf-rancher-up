# Setup local variables
locals {
  create_ssh_key_pair        = var.create_ssh_key_pair == null ? false : true
  local_ssh_private_key_path = var.ssh_private_key_path == null ? "${path.cwd}/${var.prefix}-ssh_private_key.pem" : var.ssh_private_key_path
  local_ssh_public_key_path  = var.ssh_public_key_path == null ? "${path.cwd}/${var.prefix}-ssh_public_key.pem" : var.ssh_public_key_path
  create_vpc                 = var.create_vpc == null ? false : true
  vpc                        = var.vpc == null ? module.rke2_first_server.vpc[0].name : var.vpc
  subnet                     = var.subnet == null ? module.rke2_first_server.subnet[0].name : var.subnet
  create_firewall            = var.create_firewall == null ? false : true
  kc_path                    = var.kube_config_path != null ? var.kube_config_path : path.cwd
  kc_file                    = var.kube_config_filename != null ? "${local.kc_path}/${var.kube_config_filename}" : "${local.kc_path}/${var.prefix}_kube_config.yml"
}

# Create the config.yaml for the RKE2 primary server
module "rke2_first" {
  source       = "../../../../modules/distribution/rke2"
  rke2_token   = var.rke2_token
  rke2_version = var.rke2_version
  rke2_config  = var.rke2_config
}

# Create the first VM and install the main RKE2 server
module "rke2_first_server" {
  source     = "../../../../modules/infra/google-cloud/compute-engine"
  prefix     = var.prefix
  project_id = var.project_id
  region     = var.region
  #  create_ssh_key_pair  = var.create_ssh_key_pair
  #  ssh_private_key_path = local.local_ssh_private_key_path
  #  ssh_public_key_path  = local.local_ssh_public_key_path
  #  create_vpc           = var.create_vpc
  #  vpc                  = local.vpc
  #  subnet               = local.subnet
  #  create_firewall      = local.create_firewall
  instance_count = 1
  #  instance_disk_size   = var.instance_disk_size
  #  disk_type            = var.disk_type
  #  instance_type        = var.instance_type
  #  os_image             = var.os_image
  #  ssh_username         = var.ssh_username
  startup_script = module.rke2_first.rke2_user_data
}

# Create the config.yaml for the RKE2 additional servers
module "rke2_additional" {
  source          = "../../../../modules/distribution/rke2"
  rke2_token      = module.rke2_first.rke2_token
  rke2_version    = var.rke2_version
  rke2_config     = var.rke2_config
  first_server_ip = module.rke2_first_server.instances_private_ip[0]
}

# Create the additional VMs and install the RKE2 servers
module "rke2_additional_servers" {
  source               = "../../../../modules/infra/google-cloud/compute-engine"
  prefix               = var.prefix
  project_id           = var.project_id
  region               = var.region
  create_ssh_key_pair  = local.create_ssh_key_pair
  ssh_private_key_path = local.local_ssh_private_key_path
  ssh_public_key_path  = module.rke2_first_server.public_ssh_key
  create_vpc           = var.create_vpc
  vpc                  = local.vpc
  subnet               = local.subnet
  create_firewall      = local.create_firewall
  instance_count       = var.instance_count - 1
  #  instance_disk_size   = var.instance_disk_size
  #  disk_type            = var.disk_type
  #  instance_type        = var.instance_type
  #  os_image             = var.os_image
  #  ssh_username         = var.ssh_username
  startup_script = module.rke2_additional.rke2_user_data
}

# Save the private SSH key in the Terraform data source for later use
data "local_file" "ssh_private_key" {
  depends_on = [module.rke2_additional_servers]

  filename = local.local_ssh_private_key_path
}

resource "ssh_resource" "retrieve_kubeconfig" {
  depends_on = [data.local_file.ssh_private_key]

  host = module.rke2_first_server.instances_public_ip[0]
  commands = [
    "sudo sed 's/127.0.0.1/${module.rke2_first_server.instances_public_ip[0]}/g' /etc/rancher/rke2/rke2.yaml"
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

# Wait for the RKE2 services startup 
resource "null_resource" "wait_k8s_services_startup" {
  depends_on = [local_file.kube_config_yaml]

  provisioner "local-exec" {
    command = "sleep ${var.waiting_time}"
  }
}

# Install Rancher on the RKE2 cluster
locals {
  rancher_hostname = var.rancher_hostname != null ? join(".", ["${var.rancher_hostname}", module.rke2_first_server.instances_public_ip[0], "sslip.io"]) : join(".", ["rancher", module.rke2_first_server.instances_public_ip[0], "sslip.io"])
}

module "rancher_install" {
  source                     = "../../../../modules/rancher"
  dependency                 = [null_resource.wait_k8s_services_startup]
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