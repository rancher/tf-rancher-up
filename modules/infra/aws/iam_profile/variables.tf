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
