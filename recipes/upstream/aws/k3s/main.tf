locals {
  kc_path                = var.kube_config_path != null ? var.kube_config_path : path.cwd
  kc_file                = var.kube_config_filename != null ? "${local.kc_path}/${var.kube_config_filename}" : "${local.kc_path}/${var.prefix}_kube_config.yml"
  kc_file_backup         = "${local.kc_file}.backup"
  ssh_username           = var.instance_ami != null ? var.ssh_username : var.os_type == "sles" ? "ec2-user" : "ubuntu"
  effective_server_count = var.server_instance_count != null ? var.server_instance_count : (var.instance_count != null ? var.instance_count : 1)
  effective_worker_count = var.worker_instance_count != null ? var.worker_instance_count : 0
  effective_server_spot  = var.server_spot_instances != null ? var.server_spot_instances : (var.spot_instances != null ? var.spot_instances : false)
  effective_worker_spot  = var.worker_spot_instances != null ? var.worker_spot_instances : (var.spot_instances != null ? var.spot_instances : false)
  rancher_replicas       = local.effective_server_count + local.effective_worker_count
}

module "k3s_first" {
  source      = "../../../../modules/distribution/k3s"
  k3s_token   = var.k3s_token
  k3s_version = var.k3s_version
  k3s_channel = var.k3s_channel
  k3s_config  = var.k3s_config
}

module "iam_profile" {
  source          = "../../../../modules/infra/aws/iam_profile"
  create_iam_role = var.create_iam_role
  iam_role_name   = var.iam_role_name
  prefix          = var.prefix
  aws_region      = var.aws_region
  aws_access_key  = var.aws_access_key
  aws_secret_key  = var.aws_secret_key
}

module "k3s_first_server" {
  source                  = "../../../../modules/infra/aws/ec2"
  prefix                  = "${var.prefix}-cp"
  instance_count          = 1
  instance_type           = var.instance_type
  instance_disk_size      = var.instance_disk_size
  instance_ami            = var.instance_ami
  os_type                 = var.os_type
  sles_version            = var.sles_version
  ubuntu_version          = var.ubuntu_version
  create_ssh_key_pair     = var.create_ssh_key_pair
  ssh_key_pair_name       = var.ssh_key_pair_name
  ssh_key_pair_path       = var.ssh_key_pair_path
  ssh_username            = local.ssh_username
  spot_instances          = local.effective_server_spot
  aws_region              = var.aws_region
  create_security_group   = var.create_security_group
  instance_security_group = var.instance_security_group
  restricted_access       = var.restricted_access
  create_vpc              = var.create_vpc
  vpc_cidr                = var.vpc_cidr
  public_subnets          = var.public_subnets
  private_subnets         = var.private_subnets
  subnet_id               = var.subnet_id
  user_data               = module.k3s_first.k3s_server_user_data
  aws_access_key          = var.aws_access_key
  aws_secret_key          = var.aws_secret_key
  iam_instance_profile    = var.create_iam_role ? module.iam_profile.iam_instance_profile_name : var.iam_instance_profile_name
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
  source                  = "../../../../modules/infra/aws/ec2"
  prefix                  = "${var.prefix}-cp"
  instance_count          = local.effective_server_count - 1
  instance_type           = var.instance_type
  instance_disk_size      = var.instance_disk_size
  instance_ami            = var.instance_ami
  os_type                 = var.os_type
  sles_version            = var.sles_version
  ubuntu_version          = var.ubuntu_version
  create_ssh_key_pair     = false
  ssh_key_pair_name       = module.k3s_first_server.ssh_key_pair_name
  ssh_key_pair_path       = module.k3s_first_server.ssh_key_path
  ssh_username            = local.ssh_username
  spot_instances          = local.effective_server_spot
  tag_begin               = 2
  aws_region              = var.aws_region
  create_security_group   = false
  instance_security_group = module.k3s_first_server.sg-id
  create_vpc              = false
  subnet_id               = module.k3s_first_server.public_subnets != null ? module.k3s_first_server.public_subnets : var.subnet_id
  user_data               = module.k3s_additional.k3s_server_user_data
  aws_access_key          = var.aws_access_key
  aws_secret_key          = var.aws_secret_key
  iam_instance_profile    = var.create_iam_role ? module.iam_profile.iam_instance_profile_name : var.iam_instance_profile_name
}

module "k3s_workers" {
  source                  = "../../../../modules/infra/aws/ec2"
  prefix                  = "${var.prefix}-wrk"
  instance_count          = local.effective_worker_count
  instance_type           = var.instance_type
  instance_disk_size      = var.instance_disk_size
  instance_ami            = var.instance_ami
  os_type                 = var.os_type
  sles_version            = var.sles_version
  ubuntu_version          = var.ubuntu_version
  create_ssh_key_pair     = false
  ssh_key_pair_name       = module.k3s_first_server.ssh_key_pair_name
  ssh_key_pair_path       = module.k3s_first_server.ssh_key_path
  ssh_username            = local.ssh_username
  spot_instances          = local.effective_worker_spot
  aws_region              = var.aws_region
  create_security_group   = false
  instance_security_group = module.k3s_first_server.sg-id
  create_vpc              = false
  subnet_id               = module.k3s_first_server.public_subnets != null ? module.k3s_first_server.public_subnets : var.subnet_id
  user_data               = module.k3s_additional.k3s_worker_user_data
  aws_access_key          = var.aws_access_key
  aws_secret_key          = var.aws_secret_key
  iam_instance_profile    = var.create_iam_role ? module.iam_profile.iam_instance_profile_name : var.iam_instance_profile_name
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
  user        = local.ssh_username
  private_key = data.local_file.ssh_private_key.content
}

resource "local_file" "kube_config_yaml" {
  filename        = pathexpand(local.kc_file)
  content         = ssh_resource.retrieve_kubeconfig.result
  file_permission = "0600"
}

resource "local_file" "kube_config_yaml_backup" {
  filename        = pathexpand("${local.kc_file}.backup")
  content         = ssh_resource.retrieve_kubeconfig.result
  file_permission = "0600"
}

locals {
  rancher_hostname = join(".", ["rancher", module.k3s_first_server.instances_public_ip[0], "sslip.io"])
}

module "rancher_install" {
  source                                = "../../../../modules/rancher"
  dependency                            = local.effective_worker_count > 0 ? module.k3s_workers.dependency : (local.effective_server_count > 1 ? module.k3s_additional_servers.dependency : module.k3s_first_server.dependency)
  kubeconfig_file                       = local_file.kube_config_yaml.filename
  rancher_hostname                      = local.rancher_hostname
  rancher_replicas                      = min(var.rancher_replicas, local.rancher_replicas)
  rancher_bootstrap_password            = var.rancher_bootstrap_password
  rancher_password                      = var.rancher_password
  rancher_version                       = var.rancher_version
  rancher_helm_repository               = var.rancher_helm_repository
  rancher_helm_repository_username      = var.rancher_helm_repository_username
  rancher_helm_repository_password      = var.rancher_helm_repository_password
  cert_manager_helm_repository          = var.cert_manager_helm_repository
  cert_manager_helm_repository_username = var.cert_manager_helm_repository_username
  cert_manager_helm_repository_password = var.cert_manager_helm_repository_password
  wait                                  = var.wait
}