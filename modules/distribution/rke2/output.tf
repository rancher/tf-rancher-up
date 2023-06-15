output "rke2_user_data" {
  description = "RKE2 server user data"
  value       = data.template_file.rke2_server_yaml.rendered
}

output "rke2_token" {
  description = "Token generated for RKE2"
  value       = var.rke2_token == null && var.first_server_ip == null ? random_password.token.result : var.rke2_token
  sensitive = true
}