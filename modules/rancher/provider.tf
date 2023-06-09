provider "rancher2" {
  api_url   = "https://${var.rancher_hostname}"
  bootstrap = true
  insecure  = true
}
