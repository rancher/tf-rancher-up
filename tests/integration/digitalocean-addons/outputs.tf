output "droplet_ip" {
  description = "Public IP of the K3S node"
  value       = module.infra.droplets_public_ip[0]
}

output "kubeconfig_path" {
  description = "Path to the written kubeconfig file"
  value       = local_file.kube_config_yaml.filename
}

output "longhorn_namespace" {
  description = "Namespace where Longhorn is installed"
  value       = module.longhorn.longhorn_namespace
}

output "longhorn_storage_class" {
  description = "Longhorn default storage class name"
  value       = module.longhorn.longhorn_default_storage_class_name
}

output "rancher_backup_namespace" {
  description = "Namespace where Rancher Backup Operator is installed"
  value       = module.rancher_backup.rancher_backup_namespace
}
