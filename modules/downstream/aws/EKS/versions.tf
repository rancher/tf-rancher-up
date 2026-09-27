terraform {
  required_version = ">= 1.10"
  required_providers {
    rancher2 = {
      source  = "rancher/rancher2"
      version = ">= 8.0.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0.0"
    }
  }
}