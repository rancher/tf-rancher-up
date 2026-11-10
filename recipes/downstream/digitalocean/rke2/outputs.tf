output "cluster_name" {
  value = rancher2_cluster_v2.downstream.name
}

output "cluster_id" {
  description = "Rancher (v1) cluster ID"
  value       = rancher2_cluster_v2.downstream.cluster_v1_id
}

output "instances_public_ip" {
  value = module.rke2_servers.droplets_public_ip
}

output "instances_private_ip" {
  value = module.rke2_servers.droplets_private_ip
}

output "ssh_username" {
  description = "User for SSH access to the droplets"
  value       = var.ssh_username
}

output "ssh_private_key_path" {
  description = "Private key used for SSH access to the droplets"
  value       = pathexpand(module.rke2_servers.ssh_key_path)
}

output "kube_config_path" {
  description = "Kubeconfig for the downstream cluster (proxied through Rancher)"
  value       = local_sensitive_file.kubeconfig.filename
}

output "kube_audit_log_command" {
  description = "How to read the Kubernetes API audit log on a control-plane node"
  value = (local.kube_audit_enabled ?
    "ssh -i ${pathexpand(module.rke2_servers.ssh_key_path)} ${var.ssh_username}@<node public IP> 'cat ${local.kube_audit_log_path}'" :
    "Kubernetes audit log is disabled (kube_audit_level = \"None\")"
  )
}
