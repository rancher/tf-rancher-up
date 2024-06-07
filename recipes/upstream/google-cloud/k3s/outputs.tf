output "instances_private_ip" {
  value = concat([module.k3s-first-server.instances_private_ip], [module.k3s-additional-servers.instances_private_ip])
}

output "instances_public_ip" {
  value = concat([module.k3s-first-server.instances_public_ip], [module.k3s-additional-servers.instances_public_ip])
}

output "rancher_url" {
  description = "Rancher URL"
  value       = "https://${module.rancher_install.rancher_hostname}"
}

output "rancher_password" {
  description = "Rancher Initial Custom Password"
  value       = var.rancher_password
}
