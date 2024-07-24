output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "cluster_ca_certificate" {
  value = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
}

output "client_certificate" {
  value = google_container_cluster.primary.master_auth[0].client_certificate
}

output "client_key" {
  value = google_container_cluster.primary.master_auth[0].client_key
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_host" {
  value       = google_container_cluster.primary.endpoint
  description = "GKE Cluster Host"
}

output "kubernetes_cluster_node_pool" {
  value       = google_container_node_pool.primary_nodes.name
  description = "GKE Cluster Node Pool"
}

output "kubeconfig_filename" {
  description = "Kubeconfig file location"
  value       = local.kc_file
}
