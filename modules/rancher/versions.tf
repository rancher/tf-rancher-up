terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.10.1"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = ">= 3.1.1"
    }
  }
}