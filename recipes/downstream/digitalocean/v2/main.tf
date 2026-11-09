module "downstream_rke2" {
  source = "../../../../modules/downstream/digitalocean/v2/"

  do_token            = var.do_token
  cloud_credential_id = var.cloud_credential_id
  region              = var.region
  size                = var.size
  image               = var.image
  ssh_user            = var.ssh_user
  ssh_key_fingerprint = var.ssh_key_fingerprint
  ssh_key_contents    = var.ssh_key_contents
  ssh_port            = var.ssh_port
  private_networking  = var.private_networking
  ipv6                = var.ipv6
  monitoring          = var.monitoring
  backups             = var.backups
  tags                = var.tags

  cp_count              = var.cp_count
  worker_count          = var.worker_count
  cp_node_pool_name     = var.cp_node_pool_name
  worker_node_pool_name = var.worker_node_pool_name
  machine_pools         = var.machine_pools

  custom_user_data = var.custom_user_data

  cluster_name       = var.cluster_name
  kubernetes_version = var.kubernetes_version
  cni_provider       = var.cni_provider
  rke2_ingress       = var.rke2_ingress
}