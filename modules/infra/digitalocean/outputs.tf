output "dependency" {
  value = var.droplet_count != 0 ? digitalocean_droplet.droplet[0].urn : null
}

output "droplets_public_ip" {
  value = digitalocean_droplet.droplet.*.ipv4_address
}

output "droplets_private_ip" {
  value = digitalocean_droplet.droplet.*.ipv4_address_private
}

output "droplet_ips" {
  value = [
    for i in digitalocean_droplet.droplet[*] :
    {
      public_ip  = i.ipv4_address
      private_ip = i.ipv4_address_private
    }
  ]
}

output "droplet_ids" {
  value = digitalocean_droplet.droplet[*].id
}
output "k8s_api_loadbalancer_ip" {
  value = var.create_k8s_api_loadbalancer ? digitalocean_loadbalancer.k8s_api_loadbalancer[0].ip : null
}

output "https_loadbalancer_ip" {
  value = var.create_https_loadbalancer ? digitalocean_loadbalancer.https_loadbalancer[0].ip : null
}

output "ssh_key_path" {
  value = var.create_ssh_key_pair ? local_file.private_key_pem[0].filename : var.ssh_key_pair_path
}

output "ssh_key_pair_name" {
  value = var.create_ssh_key_pair ? digitalocean_ssh_key.key_pair[0].name : var.ssh_key_pair_name
}
