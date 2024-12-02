data "digitalocean_image" "ubuntu" {
  slug = var.droplet_image
}

data "digitalocean_ssh_key" "terraform" {
  name = var.ssh_key_pair_name != null ? var.ssh_key_pair_name : resource.digitalocean_ssh_key.key_pair[0].name
}
