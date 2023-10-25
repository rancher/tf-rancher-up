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

output "ssh_private_key_path" {
  value = var.ssh_private_key_path
}

output "dependency" {
  value = var.droplet_count != 0 ? digitalocean_droplet.droplet[0].urn : null
}