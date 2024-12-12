module "rke_cluster" {
  source                     = "../../../../recipes/standalone/aws/rke"
  prefix                     = var.prefix
  aws_region                 = var.aws_region
  create_ssh_key_pair        = var.create_ssh_key_pair
  ssh_key_pair_name          = var.ssh_key_pair_name
  ssh_private_key_path       = var.ssh_private_key_path
  ssh_public_key_path        = var.ssh_public_key_path
  create_vpc                 = var.create_vpc
  vpc_id                     = var.vpc_id
  subnet_id                  = var.subnet_id
  create_security_group      = var.create_security_group
  instance_count             = var.instance_count
  instance_type              = var.instance_type
  spot_instances             = var.spot_instances
  instance_disk_size         = var.instance_disk_size
  instance_security_group_id = var.instance_security_group_id
  ssh_username               = var.ssh_username
  install_docker             = var.install_docker
  docker_version             = var.docker_version
  bastion_host               = var.bastion_host
  iam_instance_profile       = var.iam_instance_profile
  tags                       = var.tags
  kubernetes_version         = var.kubernetes_version
  kube_config_path           = var.kube_config_path
  kube_config_filename       = var.kube_config_filename
}

resource "local_file" "kube_config_yaml" {
  depends_on = [module.rke_cluster]

  filename        = "local_kube_config.yml"
  file_permission = "0600"
  content         = module.rke_cluster.kube_config_path
}

provider "kubernetes" {
  config_path = local_file.kube_config_yaml
}

provider "helm" {
  kubernetes {
    config_path = local_file.kube_config_yaml
  }
}

locals {
  rancher_hostname = var.rancher_hostname != null ? join(".", ["${var.rancher_hostname}", module.rke_cluster.instances_public_ip[0], "sslip.io"]) : join(".", ["rancher", module.rke_cluster.instances_public_ip[0], "sslip.io"])
}

module "rancher_install" {
  source                                = "../../../../modules/rancher"
  dependency                            = [local_file.kube_config_yaml]
  kubeconfig_file                       = local_file.kube_config_yaml.filename
  rancher_hostname                      = local.rancher_hostname
  rancher_bootstrap_password            = var.rancher_password
  rancher_password                      = var.rancher_password
  bootstrap_rancher                     = var.bootstrap_rancher
  rancher_version                       = var.rancher_version
  rancher_helm_repository               = var.rancher_helm_repository
  rancher_helm_repository_username      = var.rancher_helm_repository_username
  rancher_helm_repository_password      = var.rancher_helm_repository_password
  cert_manager_helm_repository          = var.cert_manager_helm_repository
  cert_manager_helm_repository_username = var.cert_manager_helm_repository_username
  cert_manager_helm_repository_password = var.cert_manager_helm_repository_password
  rancher_additional_helm_values = [
    "replicas: ${var.instance_count}"
  ]
}