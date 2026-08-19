output "iam_instance_profile_name" {
  description = "The name of the created IAM instance profile"
  value       = var.create_iam_role ? aws_iam_instance_profile.rancher_nodes[0].name : null
}
