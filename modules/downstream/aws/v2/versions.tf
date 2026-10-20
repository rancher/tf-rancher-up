terraform {
  required_providers {
    rancher2 = {
      source  = "rancher/rancher2"
      version = "~> 15.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.1.0"
    }
  }
}
