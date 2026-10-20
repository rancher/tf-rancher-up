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

    rancher2 = {
      source = "rancher/rancher2"
      # RKE1 provisioning is unsupported from Rancher 2.12 onward.
      # 8.5.0 is the last provider release with the full RKE1 resource set
      # (13.x dropped rancher2_node_template, 15.x dropped rancher2_node_pool).
      version = "~> 8.5.0"
    }
  }

  required_version = ">= 0.14"
}

provider "google" {
  credentials = var.gcp_account_json == null ? null : file(var.gcp_account_json)
  project     = var.project_id
  region      = var.region
}

provider "kubernetes" {
  config_path = "${path.cwd}/${var.prefix}_kube_config.yml"
}

provider "helm" {
  kubernetes {
    config_path = "${path.cwd}/${var.prefix}_kube_config.yml"
  }
}
