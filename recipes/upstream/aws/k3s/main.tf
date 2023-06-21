module "k3s_first" {
  source      = "../../../../modules/distribution/k3s"
  k3s_token   = var.k3s_token
  k3s_version = var.k3s_version
  k3s_config  = var.k3s_config
}

module "k3s_first_server" {
  source                  = "../../../../modules/infra/aws"
  prefix                  = var.prefix
  instance_count          = 1
  create_ssh_key_pair     = var.create_ssh_key_pair
  instance_security_group = var.ssh_key_pair_name
  ssh_key_pair_name       = var.ssh_key_pair_name
  ssh_key_pair_path       = var.ssh_key_pair_path
  ssh_username            = var.ssh_username
  spot_instances          = var.spot_instances
  aws_region              = var.aws_region
  user_data               = module.k3s_first.k3s_user_data
}

module "k3s_additional" {
  source          = "../../../../modules/distribution/k3s"
  k3s_token       = module.k3s_first.k3s_token
  k3s_version     = var.k3s_version
  k3s_config      = var.k3s_config
  first_server_ip = module.k3s_first_server.instances_private_ip[0]
}

module "k3s_additional_servers" {
  source                  = "../../../../modules/infra/aws"
  prefix                  = var.prefix
  instance_count          = var.instance_count - 1
  create_ssh_key_pair     = false
  create_security_group   = false
  instance_security_group = module.k3s_first_server.sg-id
  ssh_key_pair_name       = module.k3s_first_server.ssh_key_pair_name
  ssh_key_pair_path       = module.k3s_first_server.ssh_key_path
  ssh_username            = var.ssh_username
  spot_instances          = var.spot_instances
  tag-begin               = 2
  aws_region              = var.aws_region
  user_data               = module.k3s_additional.k3s_user_data
}

data "local_file" "ssh_private_key" {
  depends_on = [module.k3s_first_server]
  filename   = module.k3s_first_server.ssh_key_path
}

resource "ssh_resource" "retrieve_kubeconfig" {
  host = module.k3s_first_server.instances_public_ip[0]
  commands = [
    "sudo sed 's/127.0.0.1/${module.k3s_first_server.instances_public_ip[0]}/g' /etc/rancher/k3s/k3s.yaml"
  ]
  user        = var.ssh_username
  private_key = data.local_file.ssh_private_key.content
}

resource "local_file" "kube_config_server_yaml" {
  filename = var.kube_config_path != null ? var.kube_config_path : "${path.cwd}/${var.prefix}_kube_config.yml"
  content  = ssh_resource.retrieve_kubeconfig.result
}

module "rancher_install" {
  source                     = "../../../../modules/rancher"
  kubeconfig_file            = local_file.kube_config_server_yaml.filename
  rancher_hostname           = join(".", ["rancher", module.k3s_first_server.instances_public_ip[0], "sslip.io"])
  rancher_replicas           = var.instance_count
  rancher_bootstrap_password = var.rancher_password
  rancher_version            = var.rancher_version
  dependency                 = module.k3s_first_server.dependency
}