module "google-network-services" {
  source           = "../../network-services"
  resources_prefix = var.resources_prefix
  region           = var.region
}

module "google-kubernetes-engine" {
  source           = "../../kubernetes-engine"
  resources_prefix = var.resources_prefix
  project_id       = var.project_id
  region           = var.region
  vpc              = module.google-network-services.vpc_name
  subnet           = module.google-network-services.subnet_name
}
