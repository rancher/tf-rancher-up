output "instances_private_ip" {
  value = concat([module.k3s_first_server.instances_private_ip], [module.k3s_additional_servers.instances_private_ip], [module.k3s_additional_workers.instances_private_ip])
}

output "instances_public_ip" {
  value = concat([module.k3s_first_server.instances_public_ip], [module.k3s_additional_servers.instances_public_ip], [module.k3s_additional_workers.instances_public_ip])
}

output "instances_ssh_username" {
  description = "Username used for SSH login"
  value       = var.os_type
}

output "rancher_url" {
  description = "Rancher URL"
  value       = "https://${module.rancher_install.rancher_hostname}"
}

output "rancher_password" {
  description = "Rancher Initial Custom Password"
  value       = var.rancher_password
}