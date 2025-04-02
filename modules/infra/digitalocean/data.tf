data "digitalocean_image" "ubuntu" {
  slug = var.droplet_image
}

data "digitalocean_ssh_key" "terraform" {
  name = var.ssh_key_pair_name != null ? var.ssh_key_pair_name : (var.create_ssh_key_pair == false && var.rke2_installation == true ? "tf-rancher-up-${var.prefix}" : resource.digitalocean_ssh_key.key_pair[0].name)
}
