output "droplets_public_ip" {
  value = module.upstream-cluster.droplets_public_ip
}

output "droplets_private_ip" {
  value = module.upstream-cluster.droplets_private_ip
}


output "rancher_url" {
  description = "Rancher URL"
  value       = "https://${module.rancher_install.rancher_hostname}"
}

output "rancher_password" {
  value = var.rancher_password
}



