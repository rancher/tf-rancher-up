module "google-kubernetes-engine" {
  source     = "../../../../modules/distribution/gke"
  prefix     = var.prefix
  project_id = var.project_id
  region     = var.region
}

resource "null_resource" "first-setup" {
  depends_on = [module.google-kubernetes-engine.kubernetes_cluster_node_pool]
  provisioner "local-exec" {
    command = "sh ./first-setup.sh"
  }
}
