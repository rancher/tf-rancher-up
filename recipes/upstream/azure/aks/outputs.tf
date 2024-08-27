output "rancher_hostname" {
  value = local.rancher_hostname
}

output "rancher_url" {
  value = "https://${local.rancher_hostname}"
}

output "rancher_password" {
  value = var.rancher_password
}