locals {
  kubeconfig_exists = can(file(abspath(var.kubeconfig_file)))
}

provider "helm" {
  kubernetes = {
    config_path = local.kubeconfig_exists ? var.kubeconfig_file : null
  }
}

provider "kubernetes" {
  config_path = local.kubeconfig_exists ? var.kubeconfig_file : null
}

provider "rancher2" {
  api_url   = "https://${var.rancher_hostname}"
  bootstrap = true
  insecure  = true
}
