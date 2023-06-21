output "instances_public_ip" {
  value = concat([module.k3s_first_server.instances_public_ip], [module.k3s_additional_servers.instances_public_ip])
}

output "instances_private_ip" {
  value = concat([module.k3s_first_server.instances_private_ip], [module.k3s_additional_servers.instances_private_ip])
}

output "rancher_hostname" {
  value = "https://${join(".", ["rancher", module.k3s_first_server.instances_public_ip[0], "sslip.io"])}"
}

output "rancher_password" {
  value = var.rancher_password
}