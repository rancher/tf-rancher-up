provider "rancher2" {
  api_url    = var.rancher_url
  access_key = var.rancher_api_key
  secret_key = var.rancher_secret_key
  insecure   = true
}

