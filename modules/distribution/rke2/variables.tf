variable "first_server_ip" {
  type        = string
  description = "Internal IP address for the first rke2-server node"
  default     = null
}

variable "rke2_version" {
  type        = string
  description = "Kubernetes version to use for the RKE2 cluster"
  default     = null
}

variable "rke2_token" {
  description = "Token to use when configuring RKE2 nodes"
  default     = null
}

variable "rke2_config" {
  description = "Additional RKE2 configuration to add to the config.yaml file"
  default     = null
}

variable "dependency" {
  description = "An optional variable to add a dependency from another resource (not used)"
  default     = null
}

variable "user_data" {
  description = "User data content for EC2 instance(s)"
  default     = null
}

variable "auto_resolve_public_ip_address" {
  default = false
  type    = bool
}