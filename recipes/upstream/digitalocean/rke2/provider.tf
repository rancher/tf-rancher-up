terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.30.0"
    }

    ssh = {
      source  = "loafoe/ssh"
      version = ">= 2.7.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.23.0"
    }

    # modules/rancher uses the helm v3 list syntax for `set`
    helm = {
      source  = "hashicorp/helm"
      version = ">= 3.0.0"
    }

    local = {
      source  = "hashicorp/local"
      version = ">= 2.1.0"
    }
  }

  # Cross-variable validation rules need Terraform 1.9+
  required_version = ">= 1.9"
}

provider "digitalocean" {
  token = var.do_token
}
