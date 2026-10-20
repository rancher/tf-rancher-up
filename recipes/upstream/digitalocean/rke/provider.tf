terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.30.0"
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

provider "digitalocean" {
  token = var.do_token
}
