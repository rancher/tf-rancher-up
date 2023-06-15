locals {
  # create_token = var.rke2_token == null && var.first_server_ip == null ? true : false
  rke2_token = var.rke2_token == null && var.first_server_ip == null ? random_password.token.result : var.rke2_token
}

resource "random_password" "token" {
  length  = 40
  special = false
}

data "template_file" "rke2_server_yaml" {
  template = file("${path.module}/server_config.yaml.tpl")
  vars = {
    rke2_config  = var.rke2_config == null ? "false" : var.rke2_config
    rke2_token   = local.rke2_token
    rke2_version = var.rke2_version == null ? "false" : var.rke2_version
    server_ip    = var.first_server_ip == null ? "false" : var.first_server_ip
  }
}