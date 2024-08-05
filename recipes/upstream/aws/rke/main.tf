module "rke" {
  source = "../../../../recipes/standalone/aws/rke"

  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  aws_region     = var.aws_region

  dependency         = var.dependency
  prefix             = var.prefix
  instance_count     = var.instance_count
  instance_type      = var.instance_type
  instance_disk_size = var.instance_disk_size
  spot_instances     = var.spot_instances
  install_docker     = var.install_docker
  docker_version     = var.docker_version

  subnet_id               = var.subnet_id
  create_ssh_key_pair     = var.create_ssh_key_pair
  create_security_group   = var.create_security_group
  instance_security_group = var.instance_security_group

  ssh_username      = var.ssh_username
  ssh_key_pair_name = var.ssh_key_pair_name
  ssh_key_pair_path = var.ssh_key_pair_path

  kube_config_path     = var.kube_config_path
  kube_config_filename = var.kube_config_filename
  kubernetes_version   = var.kubernetes_version

}

locals {
  rancher_hostname = join(".", ["rancher", module.rke.instances_public_ip[0], "sslip.io"])
}

module "rancher_install" {
  source                                = "../../../../modules/rancher"
  dependency                            = module.rke.dependency
  kubeconfig_file                       = module.rke.kubeconfig_filename
  rancher_hostname                      = local.rancher_hostname
  rancher_replicas                      = min(var.rancher_replicas, var.instance_count)
  rancher_bootstrap_password            = var.rancher_bootstrap_password
  rancher_password                      = var.rancher_password
  rancher_version                       = var.rancher_version
  wait                                  = var.wait
  rancher_helm_repository               = var.rancher_helm_repository
  rancher_helm_repository_username      = var.rancher_helm_repository_username
  rancher_helm_repository_password      = var.rancher_helm_repository_password
  cert_manager_helm_repository          = var.cert_manager_helm_repository
  cert_manager_helm_repository_username = var.cert_manager_helm_repository_username
  cert_manager_helm_repository_password = var.cert_manager_helm_repository_password
}