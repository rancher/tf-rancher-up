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

variable "create_ssh_key_pair" {
  type        = bool
  description = "Specify if a new SSH key pair needs to be created for the instances"
  default     = false
  nullable    = false
}

variable "ssh_key_pair_name" {
  type        = string
  description = "Specify the SSH key name to use (that's already present in DigitalOcean)"
  default     = null
}

variable "ssh_key_pair_path" {
  type        = string
  description = "Path to the SSH private key used as the key pair (that's already present in DigitalOcean)"
  default     = null
}

variable "ssh_private_key_path" {
  type        = string
  description = "Path to write the generated SSH private key"
  default     = null
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
