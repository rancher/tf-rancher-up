module "google-compute-engine" {
  source              = "../../../../modules/infra/google-cloud/compute-engine"
  prefix              = var.prefix
  project_id          = var.project_id
  region              = var.region
  create_ssh_key_pair = var.create_ssh_key_pair
  startup_script      = var.startup_script
}
