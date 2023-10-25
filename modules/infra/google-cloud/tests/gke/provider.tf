terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.75.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }

  required_version = ">= 0.14"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "kubernetes" {
  config_path = "./${var.prefix}_kube_config.yml"
}
