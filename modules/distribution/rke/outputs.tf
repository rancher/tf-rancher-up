output "rke_kubeconfig_filename" {
  description = "Kubeconfig file location"
  value       = local_file.kube_config_yaml.filename
}

output "dependency" {
  value = rke_cluster.this.kube_config_yaml
}
