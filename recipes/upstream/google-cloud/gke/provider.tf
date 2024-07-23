locals {
  kubeconfig_exists = fileexists(pathexpand(module.google-kubernetes-engine.kubeconfig_filename))
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "kubernetes" {
  config_path = local.kubeconfig_exists ? module.google-kubernetes-engine.kubeconfig_filename : null
}

provider "helm" {
  kubernetes {
    config_path = local.kubeconfig_exists ? module.google-kubernetes-engine.kubeconfig_filename : null
  }
}
