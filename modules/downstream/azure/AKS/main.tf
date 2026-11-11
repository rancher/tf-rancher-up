resource "rancher2_cloud_credential" "azure_credential" {
  count       = var.cloud_credential_id != null ? 0 : 1
  name        = var.cluster_name
  description = "AZURE Credential for Terraform"
  azure_credential_config {
    client_id       = var.client_id
    client_secret   = var.client_secret
    subscription_id = var.subscription_id
  }
}

resource "rancher2_cluster" "rancheraks" {
  name        = var.cluster_name
  description = var.cluster_description
  aks_config_v2 {
    cloud_credential_id = var.cloud_credential_id != null ? var.cloud_credential_id : rancher2_cloud_credential.azure_credential[0].id
    resource_group      = var.resource_group
    resource_location   = var.resource_location
    dns_prefix          = var.dns_prefix
    kubernetes_version  = var.kubernetes_version
    network_plugin      = var.network_plugin

    dynamic "node_pools" {
      for_each = var.node_pools
      content {
        availability_zones   = node_pools.value.availability_zones
        name                 = node_pools.value.name
        count                = node_pools.value.count
        orchestrator_version = node_pools.value.orchestrator_version
        os_disk_size_gb      = node_pools.value.os_disk_size_gb
        vm_size              = node_pools.value.vm_size
      }
    }
  }
}