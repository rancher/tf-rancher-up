output "rancher_url" {
  value = join(".", ["rancher", module.rke2_first_server.rancher_ip, "sslip.io"])
}

