output "kubeconfig_file" {
  description = "The local path to the generated downstream kubeconfig"
  value       = module.downstream_rke2.kubeconfig_file
}
