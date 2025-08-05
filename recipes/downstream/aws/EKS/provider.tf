provider "rancher2" {
  insecure   = var.rancher_insecure
  api_url    = var.rancher_api_url
  access_key = var.rancher_access_key
  secret_key = var.rancher_secret_key
}