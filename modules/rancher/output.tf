output "rancher_hostname" {
  description = "Value for hostname when installing the Rancher helm chart"
  value       = var.rancher_hostname
}

output "rancher_bootstrap_password" {
  description = "Password for the Rancher admin account"
  value       = var.rancher_bootstrap_password
  sensitive   = true
}

output "rancher_admin_token" {
  description = "Rancher API token for the admin user"
  value       = rancher2_bootstrap.admin[0].token
  sensitive   = true
}
