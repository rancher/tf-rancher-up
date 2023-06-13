output "rke2_kubeconfig_filename" {
  description = "Kubeconfig file location"
  value       = local_file.kube_config_server_yaml.filename
}

output "dependency" {
  value = ssh_resource.retrieve_config.result
}

