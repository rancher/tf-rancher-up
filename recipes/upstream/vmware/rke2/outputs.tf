output "rke2_token" {
  description = "RKE2 cluster join token"
  value       = module.rke2_first.rke2_token
  sensitive   = true
}

output "instances_private_ip" {
  description = "RKE2 server node IP addresses"
  value = flatten([
    module.rke2_first_server.instances_private_ip,
    module.rke2_additional_servers[*].instances_private_ip
  ])
}

output "kubeconfig_path" {
  description = "Path to generated kubeconfig file"
  value       = local.kc_file
}

output "ssh_key_path" {
  description = "Path to SSH private key"
  value       = module.rke2_first_server.ssh_key_path
}

output "connection_command" {
  description = "SSH command to connect to first server"
  value       = "ssh -i ${module.rke2_first_server.ssh_key_path} ${var.vm_username}@${module.rke2_first_server.instances_private_ip[0]}"
}

output "rancher_url" {
  description = "Rancher UI URL"
  value       = "https://${local.rancher_hostname}"
}

output "rancher_password" {
  description = "Rancher admin password"
  value       = var.rancher_password
  sensitive   = true
}
