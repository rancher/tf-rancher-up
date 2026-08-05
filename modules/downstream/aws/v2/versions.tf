terraform {
  required_providers {
    rancher2 = {
      source  = "rancher/rancher2"
      version = ">= 8.0.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}