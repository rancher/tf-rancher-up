output "droplets_private_ip" {
  value = concat([module.k3s_first_server.droplets_private_ip], [module.k3s_additional_servers.droplets_private_ip], [module.k3s_additional_workers.droplets_private_ip])
}

output "droplets_public_ip" {
  value = concat([module.k3s_first_server.droplets_public_ip], [module.k3s_additional_servers.droplets_public_ip], [module.k3s_additional_workers.droplets_public_ip])
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
