locals {
  k3s_token               = var.k3s_token == null && var.first_server_ip == null ? random_password.token.result : var.k3s_token
  custom_user_data        = var.custom_user_data
  custom_user_data_suffix = local.custom_user_data == null ? "" : "\n\n# --- Custom user data (appended) ---\n${local.custom_user_data}\n"
}

resource "random_password" "token" {
  length  = 40
  special = false
}