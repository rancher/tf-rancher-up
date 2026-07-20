output "node_command" {
  value       = nonsensitive(module.custom_cluster.node_command)
  description = "The secure node command to register nodes to the cluster"
}

output "insecure_node_command" {
  value       = nonsensitive(module.custom_cluster.insecure_node_command)
  description = "The insecure node command to register nodes to the cluster"
}