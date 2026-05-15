module "custom_cluster" {
  source = "../../../modules/downstream/custom"

  cluster_name       = var.cluster_name
  kubernetes_version = var.kubernetes_version
}
