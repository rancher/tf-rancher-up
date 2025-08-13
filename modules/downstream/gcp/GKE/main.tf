resource "rancher2_cloud_credential" "gcp_credential" {
  count       = var.cloud_credential_id != null ? 0 : 1
  name        = var.cloud_credential_name
  description = "Terraform managed GCP cloud credential"

  google_credential_config {
    auth_encoded_json = file("${path.module}/${var.gcp_credentials_path}")
  }
}

resource "rancher2_cluster" "ranchergke" {
  name        = var.cluster_name
  description = var.cluster_description

  gke_config_v2 {
    google_credential_secret = var.cloud_credential_id != null ? var.cloud_credential_id : rancher2_cloud_credential.gcp_credential[0].id
    name                = var.cluster_name
    region              = var.region
    project_id          = var.project_id
    kubernetes_version  = var.kubernetes_version

    # Dynamic node pools
    dynamic "node_pools" {
      for_each = var.node_pools
      content {
        name                = node_pools.value.name
        initial_node_count  = node_pools.value.initial_node_count
        version             = node_pools.value.version != null ? node_pools.value.version : var.kubernetes_version
        max_pods_constraint = node_pools.value.max_pods_constraint
      }
    }
  }
}