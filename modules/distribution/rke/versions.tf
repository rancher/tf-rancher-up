terraform {
  required_providers {
    rke = {
      source  = "rancher/rke"
      version = ">= 1.5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.5.0"
    }
  }
}
