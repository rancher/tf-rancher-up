output "instances_public_ip" {
  value = concat([module.k3s_first_server.instances_public_ip], [module.k3s_additional_servers.instances_public_ip])
}

output "instances_private_ip" {
  value = concat([module.k3s_first_server.instances_private_ip], [module.k3s_additional_servers.instances_private_ip])
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

output "client_public_ip" {
  value = var.restricted_access == true ? module.k3s_first_server.client_public_ip : null
}