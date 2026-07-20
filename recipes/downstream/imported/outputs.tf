output "command" {
  value       = nonsensitive(module.imported_cluster.command)
  description = "The kubectl apply command for cluster import"
}

output "insecure_command" {
  value       = nonsensitive(module.imported_cluster.insecure_command)
  description = "The insecure kubectl apply command for cluster import"
}