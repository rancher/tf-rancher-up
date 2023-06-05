# TODO: Fix the required_version
terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
    }
    helm = {
      source = "hashicorp/helm"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
  required_version = ">= 0.13"
}
