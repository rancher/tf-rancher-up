variable "rancher_url" {
  type        = string
  description = "Rancher API URL"
}

variable "rancher_token" {
  type        = string
  description = "Rancher Token Key"
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