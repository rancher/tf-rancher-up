output "instances_public_ip" {
  value = module.rke.instances_public_ip
}

output "instances_private_ip" {
  value = module.rke.instances_private_ip
}

output "rancher_hostname" {
  value = local.rancher_hostname
}

output "rancher_url" {
  value = "https://${local.rancher_hostname}"
}

output "rancher_bootstrap_password" {
  value = var.rancher_bootstrap_password
}

output "rancher_admin_token" {
  description = "Rancher API token for the admin user"
  value       = module.rancher_install.rancher_admin_token
  sensitive   = true
}
