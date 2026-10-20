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

output "rancher_audit_log_command" {
  description = "How to read the Rancher API audit log"
  value = (
    var.rancher_audit_log_level == 0 ? "Rancher audit log is disabled (rancher_audit_log_level = 0)" :
    var.rancher_audit_log_destination == "sidecar" ?
    "kubectl --kubeconfig ${local_sensitive_file.kube_config_yaml.filename} -n cattle-system logs -l app=rancher -c rancher-audit-log --prefix --tail=-1" :
    "ssh -i ${pathexpand(module.rke2_first_server.ssh_key_path)} ${var.ssh_username}@<node running a Rancher pod> 'cat ${var.rancher_audit_log_host_path}/*.log'"
  )
}

output "kube_audit_log_command" {
  description = "How to read the Kubernetes API audit log of the Rancher (local) cluster on a node"
  value = (local.kube_audit_enabled ?
    "ssh -i ${pathexpand(module.rke2_first_server.ssh_key_path)} ${var.ssh_username}@<node public IP> 'cat ${local.kube_audit_log_path}'" :
    "Kubernetes audit log is disabled (kube_audit_level = \"None\")"
  )
}
