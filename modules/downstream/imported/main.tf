resource "rancher2_cluster" "cluster" {
  name = var.cluster_name
  annotations = {
    "rancher.io/imported-cluster-version-management" = "false"
  }
}