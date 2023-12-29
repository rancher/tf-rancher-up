output "k3s_server_user_data" {
  depends_on  = [var.dependency]
  description = "k3s server user data"
  value = templatefile("${path.module}/server_config.yaml.tpl",
    {
      k3s_config  = var.k3s_config == null ? "false" : var.k3s_config,
      k3s_channel = var.k3s_channel == null ? "stable" : var.k3s_channel,
      k3s_token   = local.k3s_token,
      k3s_version = var.k3s_version == null ? "false" : var.k3s_version,
      server_ip   = var.first_server_ip == null ? "false" : var.first_server_ip
    }
  )
}

output "k3s_worker_user_data" {
  depends_on  = [var.dependency]
  description = "k3s worker user data"
  value = templatefile("${path.module}/worker_config.yaml.tpl",
    {
      k3s_config  = var.k3s_config == null ? "false" : var.k3s_config,
      k3s_channel = var.k3s_channel == null ? "stable" : var.k3s_channel,
      k3s_token   = local.k3s_token,
      k3s_version = var.k3s_version == null ? "false" : var.k3s_version,
      server_ip   = var.first_server_ip == null ? "false" : var.first_server_ip
    }
  )
}

output "k3s_token" {
  description = "Token generated for k3s"
  value       = var.k3s_token == null && var.first_server_ip == null ? random_password.token.result : var.k3s_token
  sensitive   = true
}