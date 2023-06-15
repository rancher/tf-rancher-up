module "rke2_first" {
  source       = "../../../../modules/distribution/rke2"
  rke2_token   = var.rke2_token
  rke2_version = var.rke2_version
  rke2_config  = var.rke2_config
}

module "rke2_first_server" {
  source                  = "../../../../modules/infra/aws"
  prefix                  = "${var.prefix}"
  instance_count          = 1
  create_ssh_key_pair     = var.create_ssh_key_pair
  instance_security_group = var.ssh_key_pair_name
  ssh_key_pair_name       = var.ssh_key_pair_name
  ssh_key_pair_path       = var.ssh_key_pair_path
  ssh_username            = var.ssh_username
  spot_instances          = var.spot_instances
  aws_region              = var.aws_region
  user_data               = module.rke2_first.rke2_user_data
}

module "rke2_additional" {
  source          = "../../../../modules/distribution/rke2"
  rke2_token      = module.rke2_first.rke2_token
  rke2_version    = var.rke2_version
  rke2_config     = var.rke2_config
  first_server_ip = module.rke2_first_server.instances_private_ip[0]
}

module "rke2_additional_servers" {
  source                  = "../../../../modules/infra/aws"
  prefix                  = var.prefix
  instance_count          = var.instance_count - 1
  create_ssh_key_pair     = false
  create_security_group   = false
  instance_security_group = module.rke2_first_server.sg-id
  ssh_key_pair_name       = var.ssh_key_pair_name
  ssh_username            = var.ssh_username
  spot_instances          = var.spot_instances
  aws_region              = var.aws_region
  user_data               = module.rke2_additional.rke2_user_data
}

resource "ssh_resource" "retrieve_kubeconfig" {
  depends_on = [module.rke2_additional_servers.dependency]
  host       = module.rke2_first_server.instances_public_ip[0]
  commands = [
    "sudo sed 's/127.0.0.1/${module.rke2_first_server.instances_public_ip[0]}/g' /etc/rancher/rke2/rke2.yaml"
  ]
  user        = var.ssh_username
  private_key = module.rke2_first_server.ssh_key_path
}

resource "local_file" "kube_config_server_yaml" {
  filename = var.kube_config_path != null ? var.kube_config_path : "${path.cwd}/${var.prefix}_kube_config.yml"
  content  = ssh_resource.retrieve_kubeconfig.result
}

module "rancher_install" {
  source                     = "../../../../modules/rancher"
  kubeconfig_file            = local_file.kube_config_server_yaml.filename
  rancher_hostname           = join(".", ["rancher", module.rke2_first_server.instances_public_ip[0], "sslip.io"])
  rancher_replicas           = var.instance_count
  rancher_bootstrap_password = var.rancher_password
  rancher_version            = var.rancher_version
}