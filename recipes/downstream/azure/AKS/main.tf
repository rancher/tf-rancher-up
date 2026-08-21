module "downstream_aks" {
  source              = "../../../../modules/downstream/azure/AKS/"
  rancher_url         = var.rancher_url
  client_id           = var.client_id
  client_secret       = var.client_secret
  subscription_id     = var.subscription_id
  cloud_credential_id = var.cloud_credential_id
  cluster_name        = var.cluster_name
  cluster_description = var.cluster_description
  resource_group      = var.resource_group
  resource_location   = var.resource_location
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version
  network_plugin      = var.network_plugin
  node_pools          = var.node_pools
}