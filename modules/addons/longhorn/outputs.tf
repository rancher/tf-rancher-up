output "longhorn_namespace" {
  description = "Namespace where Longhorn is installed"
  value       = var.longhorn_namespace
}

output "longhorn_default_storage_class_name" {
  description = "Name of the Longhorn storage class (for use as a reference in downstream modules)"
  value       = "longhorn"
}
