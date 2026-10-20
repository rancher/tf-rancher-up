# TODO: Fix the required_version
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">= 2.6.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.5.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.6.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.0"
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
    time = {
      source  = "hashicorp/time"
      version = ">= 0.10.0"
    }
    rke = {
      source  = "rancher/rke"
      version = ">= 1.5.0"
    }
  }
}
