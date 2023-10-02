variable "do_token" {
  type        = string
  description = "DigitalOcean Authentication Token"
  default     = null
  sensitive   = true
}

variable "droplet_count" {
  type        = number
  description = "Number of droplets to create"
  default     = 3
  nullable    = false
}

variable "droplet_size" {
  type        = string
  description = "Size used for all droplets"
  default     = "s-2vcpu-4gb"
  nullable    = false

}

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = "rancher-terraform"
  nullable    = false
}

variable "tag_begin" {
  type        = number
  description = "Tag from this number when module is called more than once"
  default     = 1
}

variable "user_tag" {
  type        = string
  description = "FirstInitialLastname of user"
  nullable    = false
}

variable "ssh_key_name" {
  type        = string
  description = "Name of the public ssh key stored on DigitalOcean"
}

variable "ssh_private_key_path" {
  description = "Path to the private ssh key that matches the public ssh key from DigitalOcean"
  type        = string
  nullable    = false
}

variable "region" {
  description = "Region that droplets will be deployed to"
  type        = string
  default     = "sfo3"
  nullable    = false
}

variable "user_data" {
  description = "User data content for EC2 instance(s)"
  default     = null
}