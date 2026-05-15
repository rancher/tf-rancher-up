output "cluster_id" {
  value       = rancher2_cluster_v2.cluster.id
  description = "The ID of the created cluster"
}

output "node_command" {
  value       = rancher2_cluster_v2.cluster.cluster_registration_token[0].node_command
  description = "The node command to register nodes to the cluster"
}

output "insecure_node_command" {
  value       = rancher2_cluster_v2.cluster.cluster_registration_token[0].insecure_node_command
  description = "The insecure node command to register nodes to the cluster"
}
