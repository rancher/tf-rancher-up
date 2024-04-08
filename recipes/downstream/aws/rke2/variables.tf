variable "cluster_name" {
  default = "rke2-ds"
}

variable "prefix" {
  type    = string
  default = "tf"
}

variable "cloud_credential_id" {
  default = null
  type    = string
}

variable "subnet_id" {
  default = null
  type    = string
}

variable "cp_count" {
  default = 1
  type    = number
}

variable "worker_count" {
  default = 1
  type    = number
}

variable "zone" {
  type    = string
  default = "a"
}

variable "rancher_token" {
  default = null
  type    = string
}

variable "rancher_insecure" {
  default = true
}

variable "rancher_url" {
  default = null
  type    = string
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
  default = "us-west-2"
}

variable "kubernetes_version" {
  type = string
}

variable "cp_node_pool_name" {
  default = "cp"
}

variable "worker_node_pool_name" {
  default = "w"
}

variable "instance_type" {
  default = "t3a.medium"
}

variable "volume_size" {
  default = 20
  type    = number
}

variable "cni_provider" {
  default = "calico"
}

variable "spot_instances" {
  default = false
}

variable "vpc_id" {
  default = null
  type    = string
}

variable "security_group_name" {
  default = null
}

variable "ssh_user" {
  default = null
  type    = string
}

variable "ami" {
  default = null

  validation {
    condition     = can(regex("^ami-[[:alnum:]]{10}", var.ami))
    error_message = "The ami value must be a valid AMI id, starting with \"ami-\"."
  }
}