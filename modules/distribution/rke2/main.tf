locals {
  rke2_token = var.rke2_token == null && var.first_server_ip == null ? random_password.token.result : var.rke2_token
}

resource "random_password" "token" {
  length  = 40
  special = false
}