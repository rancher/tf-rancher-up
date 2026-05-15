output "cluster_id" {
  value       = rancher2_cluster.cluster.id
  description = "The ID of the created cluster"
}

output "manifest_url" {
  value       = rancher2_cluster.cluster.cluster_registration_token[0].manifest_url
  description = "The manifest URL for the cluster registration"
}

output "command" {
  value       = rancher2_cluster.cluster.cluster_registration_token[0].command
  description = "The manifest URL for the cluster registration"
}

output "insecure_command" {
  value       = rancher2_cluster.cluster.cluster_registration_token[0].insecure_command
  description = "The manifest URL for the cluster registration"
}