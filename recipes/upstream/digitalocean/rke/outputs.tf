output "droplets_public_ip" {
  value = module.upstream-cluster.droplets_public_ip
}

output "droplets_private_ip" {
  value = module.upstream-cluster.droplets_private_ip
}

output "rancher_hostname" {
  value = "https://${join(".", ["rancher", module.upstream-cluster.droplets_public_ip[0], "sslip.io"])}"
}

output "rancher_password" {
  value = var.rancher_password
}

output "ssh_key_path" {
  value = module.upstream-cluster.ssh_key_path
}

output "ssh_key_pair_name" {
  value = module.upstream-cluster.ssh_key_pair_name
}