output "rancher_url" {
  value = join(".", ["rancher", module.rke2_first_server.rancher_ip, "sslip.io"])
}

output "rancher_ip" {
  value = module.rke2_first_server.rancher_ip
}

output "rancher_hostname" {
  value = "https://${join(".", ["rancher", module.rke2_first_server.rancher_ip, "sslip.io"])}"
}

output "rancher_password" {
  value = var.rancher_password
}