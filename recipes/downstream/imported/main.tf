module "imported_cluster" {
  source = "../../../modules/downstream/imported"

  cluster_name = var.cluster_name
}
