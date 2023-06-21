locals {
  # create_token = var.k3s_token == null && var.first_server_ip == null ? true : false
  k3s_token = var.k3s_token == null && var.first_server_ip == null ? random_password.token.result : var.k3s_token
}

resource "random_password" "token" {
  length  = 40
  special = false
}