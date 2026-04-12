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
  type        = string
  description = "Token to use when configuring RKE2 nodes"
  default     = null
}

variable "rke2_config" {
  type        = string
  description = "Additional RKE2 configuration to add to the config.yaml file"
  default     = null
}

variable "dependency" {
  type        = any
  description = "An optional variable to add a dependency from another resource (not used)"
  default     = null
}

variable "rke2_ingress" {
  description = "RKE2 ingress deployed (nginx or traefik)"
  type        = string
  default     = "ingress-nginx"
}