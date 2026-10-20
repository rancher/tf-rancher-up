terraform {
  required_version = ">= 1.10"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.10.0"
    }
    rancher2 = {
      source = "rancher/rancher2"
      # Shared by RKE1 and RKE2/K3s upstream recipes: the calling recipe
      # decides the provider generation (see scripts/check_rancher2_version.sh).
      version = ">= 8.5"
    }
  }
}