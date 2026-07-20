variable "rancher_url" {
  type        = string
  description = "The Rancher server URL"
}

variable "rancher_token" {
  type        = string
  description = "Rancher API token"
  sensitive   = true
}

variable "rancher_insecure" {
  type    = bool
  default = true
}

variable "cluster_name" {
  type        = string
  description = "Name of the imported cluster"
  default     = "imported-cluster"
}