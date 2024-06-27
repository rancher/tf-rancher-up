output "instances_private_ip" {
  value = concat([module.rke2-first-server.instances_private_ip], [module.rke2-additional-servers.instances_private_ip])
}

output "instances_public_ip" {
  value = concat([module.rke2-first-server.instances_public_ip], [module.rke2-additional-servers.instances_public_ip])
}

output "vpc" {
  value = module.rke2-first-server.vpc[0].id
}

output "subnet" {
  value = module.rke2-first-server.subnet[0].id
}

output "security_group" {
  value = module.rke2-first-server.security_group[0].id
}

# Uncomment for debugging purposes
#output "rke2_first_server_config_file" {
#  value = nonsensitive(module.rke2-first.rke2_user_data)
#}

# Uncomment for debugging purposes
#output "rke2_additional_servers_config_file" {
#  value = nonsensitive(module.rke2-additional.rke2_user_data)
#}

output "rancher_url" {
  description = "Rancher URL"
  value       = "https://${module.rancher_install.rancher_hostname}"
}

output "rancher_password" {
  description = "Rancher Initial Custom Password"
  value       = var.rancher_password
}
