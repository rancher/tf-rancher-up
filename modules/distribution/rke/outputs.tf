output "rke_kubeconfig_filename" {
  description = "Kubeconfig file location"
  value       = var.create_kubeconfig_file ? local_file.kube_config_yaml[0].filename : null
}

output "kube_config_yaml" {
  value = rke_cluster.this.kube_config_yaml
}

output "dependency" {
  value = rke_cluster.this.kube_config_yaml
}

output "credentials" {
  value = {
    host = rke_cluster.this.api_server_url

    client_certificate     = rke_cluster.this.client_cert
    client_key             = rke_cluster.this.client_key
    cluster_ca_certificate = rke_cluster.this.ca_crt
  }
}
