output "instances_public_ip" {
  value = concat([module.rke2_first_server.instances_public_ip], [module.rke2_additional_servers.instances_public_ip])
}

output "instances_private_ip" {
  value = concat([module.rke2_first_server.instances_private_ip], [module.rke2_additional_servers.instances_private_ip])
}

output "rancher_hostname" {
  value = local.rancher_hostname
}

output "rancher_url" {
  value = "https://${local.rancher_hostname}"
}

output "rancher_password" {
  value = var.rancher_password
}

output "rancher_admin_token" {
  description = "Rancher API token for the admin user"
  value       = module.rancher_install.rancher_admin_token
  sensitive   = true
}
