terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.30.0"
    }
  }

  required_version = ">= 0.14"
}

provider "digitalocean" {
  token = var.do_token
}
