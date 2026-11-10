output "instances_private_ip" {
  value = concat(module.rke2_first_server.droplets_private_ip, module.rke2_additional_servers.droplets_private_ip)
}

output "instances_public_ip" {
  value = concat(module.rke2_first_server.droplets_public_ip, module.rke2_additional_servers.droplets_public_ip)
}

output "ssh_username" {
  description = "User for SSH access to the droplets"
  value       = var.ssh_username
}

output "ssh_private_key_path" {
  description = "Private key used for SSH access to the droplets"
  value       = pathexpand(module.rke2_first_server.ssh_key_path)
}

output "kube_config_path" {
  description = "Kubeconfig for the Rancher (local) cluster"
  value       = local_sensitive_file.kube_config_yaml.filename
}

# # Uncomment for debugging purposes
# output "rke2_first_server_config_file" {
#  value = nonsensitive(module.rke2_first.rke2_user_data)
# }
#
# # Uncomment for debugging purposes
# output "rke2_additional_servers_config_file" {
#  value = nonsensitive(module.rke2_additional.rke2_user_data)
# }

output "rancher_url" {
  description = "Rancher URL"
  value       = "https://${module.rancher_install.rancher_hostname}"
}

output "rancher_token" {
  description = "Rancher API token for the admin user (read by the downstream recipes)"
  value       = module.rancher_install.rancher_admin_token
  sensitive   = true
}

