terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.16.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.8.0"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = ">= 3.0.0"
    }
  }
}