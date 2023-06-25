variable "first_server_ip" {
  type        = string
  description = "Internal IP address for the first k3s-server node"
  default     = null
}

variable "k3s_version" {
  type        = string
  description = "Kubernetes version to use for the k3s cluster"
  default     = null
}

variable "k3s_token" {
  description = "Token to use when configuring k3s nodes"
  default     = null
}

variable "k3s_channel" {
  type        = string
  description = "K3s channel to use, the latest patch version for the provided minor version will be used"
  default     = null
}

variable "k3s_config" {
  description = "Additional k3s configuration to add to the config.yaml file"
  default     = null
}

variable "dependency" {
  description = "An optional variable to add a dependency from another resource (not used)"
  default     = null
}