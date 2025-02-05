terraform {
  required_providers {
    rke = {
      source  = "rancher/rke"
      version = ">= 1.7.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.1.0"
    }
  }
}
