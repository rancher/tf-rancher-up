terraform {
  required_providers {
    rancher2 = {
      source  = "rancher/rancher2"
      version = ">= 8.0.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.30.0"
    }
    ssh = {
      source  = "loafoe/ssh"
      version = ">= 2.7.0"
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

provider "rancher2" {
  api_url   = local.api_url
  token_key = local.token_key
  insecure  = var.rancher_insecure
}
