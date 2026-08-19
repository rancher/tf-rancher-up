variable "create_iam_role" {
  description = "Whether to create an IAM role"
  type        = bool
  default     = false
}

variable "iam_role_name" {
  description = "The name of the IAM role to create"
  type        = string
  default     = null
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_access_key" {
  type    = string
  default = null
}

variable "aws_secret_key" {
  type    = string
  default = null
}
