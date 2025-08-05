
variable "rancher_api_url" {
  description = "Rancher server API URL"
  type        = string
}

variable "rancher_insecure" {
  description = "Skip TLS verification for Rancher API"
  type        = bool
  default     = true
}

variable "rancher_access_key" {
  description = "Rancher access key"
  type        = string
  sensitive   = true
}

variable "rancher_secret_key" {
  description = "Rancher secret key"
  type        = string
  sensitive   = true
}


variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}


variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}


variable "cluster_name" {
  description = "Name of the Rancher EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.32"
}

variable "aws_region" {
  description = "AWS region to deploy EKS cluster"
  type        = string
  default     = "ap-south-1"
}

variable "cloud_credential_name" {
  description = "Name for the cloud credential"
  type        = string
  default     = "eks-cloud-cred-from-tf"
}

variable "cloud_credential_description" {
  description = "Description for the cloud credential"
  type        = string
  default     = "Auto-created credentials for EKS"
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

variable "cluster_description" {
  description = "EKS cluster description"
  type        = string
  default     = "Terraform managed EKS cluster"
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