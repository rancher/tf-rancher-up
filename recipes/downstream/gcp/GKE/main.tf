module "downstream_gke" {
  source = "../../../../modules/downstream/gcp/GKE/"

  rancher_url           = var.rancher_url
  cloud_credential_id   = var.cloud_credential_id
  cluster_name          = var.cluster_name
  cluster_description   = var.cluster_description
  project_id            = var.project_id
  region                = var.region
  kubernetes_version    = var.kubernetes_version
  gcp_credentials_path  = var.gcp_credentials_path
  cloud_credential_name = var.cloud_credential_name
  node_pools            = var.node_pools

}