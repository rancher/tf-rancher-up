module "google-kubernetes-engine" {
  source     = "../../../../modules/distribution/gke"
  prefix     = var.prefix
  project_id = var.project_id
  region     = var.region
}
