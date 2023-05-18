output "rancher_hostname" {
  description = "Value for hostname when installing the Rancher helm chart"
  value       = var.rancher_hostname
}

output "rancher_bootstrap_password" {
  description = "Password to use for bootstrapping Rancher"
  value       = var.rancher_bootstrap_password
  sensitive   = true
}