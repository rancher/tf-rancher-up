output "kubeconfig_file" {
  description = "The local path to the generated downstream kubeconfig"
  value       = local_sensitive_file.kubeconfig.filename
}
