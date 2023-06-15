output "instances_public_ip" {
  value = concat([module.rke2_first_server.instances_public_ip], [module.rke2_additional_servers.instances_public_ip])
}

output "instances_private_ip" {
  value = concat([module.rke2_first_server.instances_private_ip], [module.rke2_additional_servers.instances_private_ip])
}

output "rancher_hostname" {
  value = "https://${join(".", ["rancher", module.rke2_first_server.instances_public_ip[0], "sslip.io"])}"
}

output "rancher_password" {
  value = var.rancher_password
}