provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = var.vsphere_allow_unverified_ssl
}

provider "kubernetes" {
  config_path = local.kc_file
  insecure    = true
}

provider "helm" {
  kubernetes {
    config_path = local.kc_file
    insecure    = true
  }
}

provider "rancher2" {
  api_url   = "https://${local.rancher_hostname}"
  insecure  = true
  bootstrap = true
}
