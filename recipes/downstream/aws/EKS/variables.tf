
variable "rancher_token" {
  description = "Rancher API token"
  default     = null
  type        = string
}

variable "rancher_insecure" {
  description = "Allow insecure connections to Rancher"
  default     = true
}

variable "rancher_url" {
  description = "The Rancher server URL"
  default     = null
  type        = string
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  default     = null
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  default     = null
  sensitive   = true
}

variable "cluster_name" {
  description = "Name of the Rancher EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = null
}

variable "aws_region" {
  type        = string
  description = "AWS region used for all resources"
  default     = "us-east-1"

  validation {
    condition = contains([
      "us-east-2",
      "us-east-1",
      "us-west-1",
      "us-west-2",
      "af-south-1",
      "ap-east-1",
      "ap-south-2",
      "ap-southeast-3",
      "ap-southeast-4",
      "ap-south-1",
      "ap-northeast-3",
      "ap-northeast-2",
      "ap-southeast-1",
      "ap-southeast-2",
      "ap-northeast-1",
      "ca-central-1",
      "ca-west-1",
      "eu-central-1",
      "eu-west-1",
      "eu-west-2",
      "eu-south-1",
      "eu-west-3",
      "eu-south-2",
      "eu-north-1",
      "eu-central-2",
      "il-central-1",
      "me-south-1",
      "me-central-1",
      "sa-east-1",
    ], var.aws_region)
    error_message = "Invalid Region specified!"
  }
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

variable "cloud_credential_id" {
  description = "Rancher cloud credential to use, instead of AWS access/secret key (ex: cattle-global-data:cc-xxx)"
  default     = null
  type        = string
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