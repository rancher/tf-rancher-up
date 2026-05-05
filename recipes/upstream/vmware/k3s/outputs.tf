output "first_server_ip" {
  description = "The IP address of the first K3s server."
  value       = module.k3s_first_server.instances_private_ip[0]
}

output "first_server_ssh_key_path" {
  description = "Path to the SSH private key for the first K3s server."
  value       = module.k3s_first_server.ssh_key_path
}

output "additional_servers_ips" {
  description = "The IP addresses of additional K3s servers."
  value       = flatten(module.k3s_additional_servers[*].instances_private_ip)
}

output "kube_config_path" {
  description = "The path pointing to the locally retrieved kubeconfig file."
  value       = local.kc_file
}

output "rancher_url" {
  description = "The Rancher URL."
  value       = "https://${local.rancher_hostname}"
}

output "rancher_bootstrap_password" {
  description = "Rancher initial Bootstrap Password."
  value       = var.rancher_bootstrap_password
  sensitive   = true
}

output "rancher_password" {
  description = "Rancher Admin Password."
  value       = var.rancher_password
  sensitive   = true
}
