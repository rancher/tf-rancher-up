output "rancher_url" {
  value       = "https://${module.rancher_install.rancher_hostname}"
  description = "Rancher URL"
}

output "rancher_password" {
  value       = var.rancher_password
  description = "Rancher admin password"
  sensitive   = true
}

output "kube_config_path" {
  value       = local.kc_file
  description = "Path to the kubeconfig file"
}

output "instances_public_ip" {
  value       = module.vms.instances_private_ip
  description = "IP addresses of the VMs (using private IP as public if identical)"
}

output "ssh_key_path" {
  value       = local.ssh_private_key_path
  description = "Path to the SSH private key"
}