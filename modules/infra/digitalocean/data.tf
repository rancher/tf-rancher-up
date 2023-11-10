data "digitalocean_image" "ubuntu" {
  slug = "ubuntu-22-04-x64"
}

data "digitalocean_ssh_key" "terraform" {
  name = resource.digitalocean_ssh_key.terraform.name 
}
