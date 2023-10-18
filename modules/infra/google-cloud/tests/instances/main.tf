module "google-compute-engine" {
  source         = "../../compute-engine"
  prefix         = var.prefix
  project_id     = var.project_id
  region         = var.region
  startup_script = var.startup_script
}
