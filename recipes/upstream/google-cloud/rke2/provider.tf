terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0.0"
    }

    ssh = {
      source  = "loafoe/ssh"
      version = ">= 2.7.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.10.0"
    }
  }

  required_version = ">= 0.14"
}

provider "google" {
  credentials = var.gcp_account_json == null ? null : file(var.gcp_account_json)
  project     = var.project_id
  region      = var.region
}
