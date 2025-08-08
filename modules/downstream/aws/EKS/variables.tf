
variable "cluster_name" {
  description = "The cluster name"
  default     = null
}

variable "cluster_description" {
  description = "EKS cluster description"
  type        = string
  default     = null
}

variable "rancher_token" {
  description = "Rancher API token"
  default     = null
  type        = string
}

variable "rancher_insecure" {
  description = "Skip TLS verification for Rancher API"
  type        = bool
  default     = true
}

variable "rancher_url" {
  description = "The Rancher server URL"
  default     = null
  type        = string
}

variable "aws_access_key" {
  type        = string
  description = "AWS access key used to create infrastructure"
  default     = null
}

variable "aws_secret_key" {
  type        = string
  description = "AWS secret key used to create AWS infrastructure"
  default     = null
}

variable "aws_region" {
  type        = string
  description = "AWS region used for all resources"
  default     = "us-west-2"
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.32"
}

variable "cloud_credential_id" {
  description = "Rancher cloud credential to use, instead of AWS access/secret key (ex: cattle-global-data:cc-xxx)"
  default     = null
  type        = string
}

variable "logging_types" {
  description = "EKS control plane logging types"
  type        = list(string)
  default     = ["audit", "api"]
}

variable "node_groups" {
  description = "Configuration for EKS node groups"
  type = list(object({
    name          = string
    instance_type = string
    desired_size  = number
    max_size      = number
    min_size      = number
  }))

  validation {
    condition = alltrue([
      for ng in var.node_groups : ng.desired_size >= 2
    ])
    error_message = "Each node group must have at least 2 desired nodes. The desired_size value in each node group configuration should be >= 2."
  }

  validation {
    condition = alltrue([
      for ng in var.node_groups : ng.max_size >= ng.desired_size
    ])
    error_message = "Max size must be greater than or equal to desired size."
  }

  validation {
    condition = alltrue([
      for ng in var.node_groups : ng.desired_size >= ng.min_size
    ])
    error_message = "Desired size must be greater than or equal to min size."
  }
}

variable "private_access" {
  description = "Enable private API server endpoint"
  type        = bool
  default     = true
}

variable "public_access" {
  description = "Enable public API server endpoint"
  type        = bool
  default     = true
}