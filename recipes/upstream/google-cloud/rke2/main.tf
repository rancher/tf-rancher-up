module "rke2-first" {
  source       = "../../../../modules/distribution/rke2"
  rke2_token   = var.rke2_token
  rke2_version = var.rke2_version
  rke2_config  = var.rke2_config
}

module "rke2-first-server" {
  source     = "../../../../modules/infra/google-cloud/compute-engine"
  prefix     = var.prefix
  project_id = var.project_id
  region     = var.region
  #  create_ssh_key_pair  = var.create_ssh_key_pair
  #  ssh_private_key_path = var.ssh_private_key_path
  #  ssh_public_key_path  = var.ssh_public_key_path
  #  vpc                  = var.vpc
  #  subnet               = var.subnet
  #  firewall             = var.firewall
  instance_count = 1
  #  instance_disk_size   = var.instance_disk_size
  #  disk_type            = var.disk_type
  #  instance_type        = var.instance_type
  #  os_image             = var.os_image
  #  ssh_username         = var.ssh_username
  startup_script = module.rke2-first.rke2_user_data
}

locals {
  vpc                  = var.vpc == null ? "${var.prefix}-vpc" : var.vpc
  subnet               = var.subnet == null ? "${var.prefix}-subnet" : var.subnet
  firewall             = var.firewall == null ? false : true
  private_ssh_key_path = fileexists("${path.cwd}/${var.prefix}-ssh_private_key.pem") ? "${path.cwd}/${var.prefix}-ssh_private_key.pem" : var.ssh_private_key_path
  public_ssh_key_path  = fileexists("${path.cwd}/${var.prefix}-ssh_public_key.pem") ? "${path.cwd}/${var.prefix}-ssh_public_key.pem" : var.ssh_public_key_path
}

module "rke2-additional" {
  source          = "../../../../modules/distribution/rke2"
  rke2_token      = module.rke2-first.rke2_token
  rke2_version    = var.rke2_version
  rke2_config     = var.rke2_config
  first_server_ip = module.rke2-first-server.instances_private_ip[0]
}

module "rke2-additional-servers" {
  source     = "../../../../modules/infra/google-cloud/compute-engine"
  prefix     = var.prefix
  project_id = var.project_id
  region     = var.region
  #  create_ssh_key_pair  = var.create_ssh_key_pair
  ssh_private_key_path = local.private_ssh_key_path
  ssh_public_key_path  = local.public_ssh_key_path
  vpc                  = local.vpc
  subnet               = local.subnet
  firewall             = local.firewall
  instance_count       = var.instance_count - 1
  #  instance_disk_size   = var.instance_disk_size
  #  disk_type            = var.disk_type
  #  instance_type        = var.instance_type
  #  os_image             = var.os_image
  #  ssh_username         = var.ssh_username
  startup_script = module.rke2-additional.rke2_user_data
}

resource "null_resource" "customize-rke2-nginx-ingress-controller" {
  depends_on = [module.rke2-additional-servers]
  provisioner "local-exec" {
    command     = "sh ./rke2-ingress-nginx-setup.sh"
  }
}

locals {
  kc_path        = var.kube_config_path != null ? var.kube_config_path : path.cwd
  kc_file        = var.kube_config_filename != null ? "${local.kc_path}/${var.kube_config_filename}" : "${local.kc_path}/${var.prefix}_kube_config.yml"
  kc_file_backup = "${local.kc_file}.backup"
}

data "local_file" "ssh-private-key" {
  depends_on = [module.rke2-first-server]
  filename   = local.private_ssh_key_path
}

resource "ssh_resource" "retrieve-kubeconfig" {
  host = module.rke2-first-server.instances_public_ip[0]
  commands = [
    "sudo sed 's/127.0.0.1/${module.rke2-first-server.instances_public_ip[0]}/g' /etc/rancher/rke2/rke2.yaml"
  ]
  user        = var.ssh_username
  private_key = data.local_file.ssh-private-key.content
}

resource "local_file" "kube-config-yaml" {
  filename        = local.kc_file
  content         = ssh_resource.retrieve-kubeconfig.result
  file_permission = "0600"
}

resource "local_file" "kube-config-yaml-backup" {
  filename        = local.kc_file_backup
  content         = ssh_resource.retrieve-kubeconfig.result
  file_permission = "0600"
}

resource "null_resource" "wait-k8s-services-startup" {
  depends_on = [null_resource.customize-rke2-nginx-ingress-controller]
  provisioner "local-exec" {
    command = "sleep 180"
  }
}

data "kubernetes_service" "rke2-ingress-nginx-controller-svc" {
  metadata {
    name      = "rke2-ingress-nginx-controller-admission"
    namespace = "kube-system"
  }
}

locals {
  rancher_hostname = var.rancher_hostname != null ? join(".", ["${var.rancher_hostname}", module.rke2-first-server.instances_public_ip[0], "sslip.io"]) : join(".", ["rancher", module.rke2-first-server.instances_public_ip[0], "sslip.io"])
}

module "rancher_install" {
  source                     = "../../../../modules/rancher"
  dependency                 = [data.kubernetes_service.rke2-ingress-nginx-controller-svc]
  kubeconfig_file            = "${path.cwd}/${var.prefix}_kube_config.yml"
  rancher_hostname           = local.rancher_hostname
  rancher_bootstrap_password = var.rancher_password
  rancher_password           = var.rancher_password
  #bootstrap_rancher          = var.bootstrap_rancher
  #  rancher_version            = var.rancher_version
  rancher_additional_helm_values = [
    "replicas: 3",
    "ingress.ingressClassName: nginx",
    "service.type: ClusterIP"
  ]
}
