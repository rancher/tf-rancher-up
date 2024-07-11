output "droplets_public_ip" {
  value = module.upstream-cluster.droplets_public_ip
}

output "droplets_private_ip" {
  value = module.upstream-cluster.droplets_private_ip
}

output "rancher_hostname" {
  value = module.rancher_install.rancher_hostname
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

output "droplet_ids" {
  value = module.upstream-cluster.droplet_ids
}
output "k8s_api_loadbalancer_ip" {
  value = module.upstream-cluster.k8s_api_loadbalancer_ip
}

output "https_loadbalancer_ip" {
  value = module.upstream-cluster.https_loadbalancer_ip
}

