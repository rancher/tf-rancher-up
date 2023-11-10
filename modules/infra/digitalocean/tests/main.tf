variable "do_token" {
  type      = string
  sensitive = true
}

module "upstream_cluster" {
  source               = "../"
  do_token             = var.do_token
  user_tag             = "rancherdev"
  droplet_count        = 2
  create_ssh_key_pair = false
  ssh_private_key_path = "~/.ssh/id_ed25519"
  ssh_public_key_path = "~/.ssh/id_ed25519.pub"
}
