locals {
  create_ssh_key_pair        = var.create_ssh_key_pair == null ? false : true
  ssh_key_pair_name          = var.ssh_key_pair_name == null ? "tf-rancher-up-${var.prefix}" : var.ssh_key_pair_name
  local_ssh_private_key_path = var.ssh_private_key_path == null ? "${path.cwd}/${var.prefix}-ssh_private_key.pem" : var.ssh_private_key_path
  local_ssh_public_key_path  = var.ssh_public_key_path == null ? "${path.cwd}/${var.prefix}-ssh_public_key.pem" : var.ssh_public_key_path
  create_vpc                 = var.create_vpc == null ? false : true
  vpc_id                     = var.vpc_id == null ? module.rke2-first-server.vpc[0].id : var.vpc_id
  subnet_id                  = var.subnet_id == null ? module.rke2-first-server.subnet[0].id : var.subnet_id
  create_security_group      = var.create_security_group == null ? false : true
  instance_security_group_id = local.create_security_group == "true" ? null : module.rke2-first-server.security_group[0].id
  kc_path                    = var.kube_config_path != null ? var.kube_config_path : path.cwd
  kc_file                    = var.kube_config_filename != null ? "${local.kc_path}/${var.kube_config_filename}" : "${local.kc_path}/${var.prefix}_kube_config.yml"
  kc_file_backup             = "${local.kc_file}.backup"
}

module "rke2-first" {
  source       = "../../../../modules/distribution/rke2"
  rke2_token   = var.rke2_token
  rke2_version = var.rke2_version
  rke2_config  = var.rke2_config
}

module "rke2-first-server" {
  source     = "../../../../modules/infra/aws/ec2"
  prefix     = var.prefix
  aws_region = var.aws_region
  #  create_ssh_key_pair   = var.create_ssh_key_pair
  #  ssh_key_pair_name     = var.ssh_key_pair_name
  #  ssh_private_key_path  = var.ssh_private_key_path
  #  ssh_public_key_path   = var.ssh_public_key_path
  #  create_vpc            = var.create_vpc
  #  vpc_id                = var.vpc_id
  #  subnet_id             = var.subnet_id
  #  create_security_group = var.create_security_group
  instance_count = 1
  #  instance_type              = var.instance_type
  #  spot_instances             = var.spot_instances
  #  instance_disk_size         = var.instance_disk_size
  #  instance_security_group_id = var.instance_security_group_id
  ssh_username = var.ssh_username
  user_data    = module.rke2-first.rke2_user_data
}

module "rke2-additional" {
  source          = "../../../../modules/distribution/rke2"
  rke2_token      = module.rke2-first.rke2_token
  rke2_version    = var.rke2_version
  rke2_config     = var.rke2_config
  first_server_ip = module.rke2-first-server.instances_private_ip[0]
}

module "rke2-additional-servers" {
  source                = "../../../../modules/infra/aws/ec2"
  prefix                = var.prefix
  aws_region            = var.aws_region
  create_ssh_key_pair   = local.create_ssh_key_pair
  ssh_key_pair_name     = local.ssh_key_pair_name
  ssh_private_key_path  = local.local_ssh_private_key_path
  ssh_public_key_path   = local.local_ssh_public_key_path
  create_vpc            = local.create_vpc
  vpc_id                = local.vpc_id
  subnet_id             = local.subnet_id
  create_security_group = local.create_security_group
  instance_count        = var.instance_count - 1
  #  instance_type              = var.instance_type
  #  spot_instances             = var.spot_instances
  #  instance_disk_size         = var.instance_disk_size
  instance_security_group_id = local.instance_security_group_id
  ssh_username               = var.ssh_username
  user_data                  = module.rke2-additional.rke2_user_data
}

data "local_file" "ssh_private_key" {
  depends_on = [module.rke2-first-server]
  filename   = local.local_ssh_private_key_path
}

resource "ssh_resource" "retrieve-kubeconfig" {
  host = module.rke2-first-server.instances_public_ip[0]
  commands = [
    "sudo sed 's/127.0.0.1/${module.rke2-first-server.instances_public_ip[0]}/g' /etc/rancher/rke2/rke2.yaml"
  ]
  user        = var.ssh_username
  private_key = data.local_file.ssh_private_key.content
}

resource "local_file" "kube-config-yaml" {
  filename        = local.kc_file
  file_permission = "0600"
  content         = ssh_resource.retrieve-kubeconfig.result
}

resource "local_file" "kube-config-yaml-backup" {
  filename        = local.kc_file_backup
  file_permission = "0600"
  content         = ssh_resource.retrieve-kubeconfig.result
}

resource "null_resource" "wait-k8s-services-startup" {
  depends_on = [module.rke2-additional-servers]
  provisioner "local-exec" {
    command = "sleep ${var.waiting_time}"
  }
}

locals {
  rancher_hostname = var.rancher_hostname != null ? join(".", ["${var.rancher_hostname}", module.rke2-first-server.instances_public_ip[0], "sslip.io"]) : join(".", ["rancher", module.rke2-first-server.instances_public_ip[0], "sslip.io"])
}

module "rancher_install" {
  source                     = "../../../../modules/rancher"
  dependency                 = [null_resource.wait-k8s-services-startup]
  kubeconfig_file            = local.kc_file
  rancher_hostname           = local.rancher_hostname
  rancher_bootstrap_password = var.rancher_password
  rancher_password           = var.rancher_password
  bootstrap_rancher          = var.bootstrap_rancher
  rancher_version            = var.rancher_version
  rancher_additional_helm_values = [
    "replicas: ${var.instance_count}",
    "ingress.ingressClassName: ${var.rancher_ingress_class_name}",
    "service.type: ${var.rancher_service_type}"
  ]
}
