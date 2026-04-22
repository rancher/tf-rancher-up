locals {
  kc_path = var.kube_config_path != null ? var.kube_config_path : path.cwd
  kc_file = var.kube_config_filename != null ? "${local.kc_path}/${var.kube_config_filename}" : "${local.kc_path}/${var.prefix}_kube_config.yml"
}

# K3S cloud-init user_data for the single control-plane node
module "k3s_config" {
  source      = "../../../modules/distribution/k3s"
  k3s_version = var.k3s_version
  k3s_channel = var.k3s_channel
}

# Provision a single Ubuntu droplet; create_ssh_key_pair generates a fresh key pair
module "infra" {
  source              = "../../../modules/infra/digitalocean"
  prefix              = var.prefix
  droplet_count       = 1
  droplet_size        = var.droplet_size
  region              = var.region
  os_type             = "ubuntu"
  create_ssh_key_pair = true
  user_data           = module.k3s_config.k3s_server_user_data

  # Disable optional resources we don't need for addon testing
  create_firewall             = false
  create_https_loadbalancer   = false
  create_k8s_api_loadbalancer = false
  rke2_installation           = false
}

# Read the generated private key so we can SSH in
data "local_file" "ssh_private_key" {
  depends_on = [module.infra]
  filename   = module.infra.ssh_key_path
}

# Pull the kubeconfig from the K3S server once it's up
resource "ssh_resource" "retrieve_kubeconfig" {
  depends_on = [module.infra]

  host = module.infra.droplets_public_ip[0]
  commands = [
    "sudo sed 's/127.0.0.1/${module.infra.droplets_public_ip[0]}/g' /etc/rancher/k3s/k3s.yaml"
  ]
  user        = var.ssh_username
  private_key = data.local_file.ssh_private_key.content
}

# Write kubeconfig to disk so addon modules can consume it
resource "local_file" "kube_config_yaml" {
  filename        = pathexpand(local.kc_file)
  content         = ssh_resource.retrieve_kubeconfig.result
  file_permission = "0600"
}

# Deploy Longhorn (single replica — single-node cluster)
module "longhorn" {
  source = "../../../modules/addons/longhorn"

  kubeconfig_file                = local_file.kube_config_yaml.filename
  longhorn_version               = var.longhorn_version
  longhorn_default_replica_count = var.longhorn_default_replica_count
  longhorn_default_storage_class = true
  dependency                     = local_file.kube_config_yaml.filename
}

# Deploy Rancher Backup Operator (PVC backend, using Longhorn storage class)
module "rancher_backup" {
  source = "../../../modules/addons/rancher-backup-operator"

  kubeconfig_file                  = local_file.kube_config_yaml.filename
  rancher_backup_storage_backend   = "pvc"
  rancher_backup_pvc_storage_class = module.longhorn.longhorn_default_storage_class_name
  rancher_backup_pvc_size          = "5Gi"
  dependency                       = module.longhorn.longhorn_namespace
}
