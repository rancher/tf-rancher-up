variable "do_token" {
  type      = string
  sensitive = true
}

variable "ssh_key" {
  type = string
}

variable "private_key" {
  type = string
}

module "upstream_cluster" {
  source               = "../"
  do_token             = var.do_token
  user_tag             = "rancherdev"
  ssh_key_name         = var.ssh_key
  droplet_count        = 2
  ssh_private_key_path = var.private_key
}