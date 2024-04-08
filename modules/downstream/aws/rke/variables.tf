variable "cluster_name" {
  default = "rke-ds"
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

variable "node_template_name" {
  default = "tf"
  type    = string
}

variable "aws_access_key" {
  default = null
  type    = string
}

variable "aws_secret_key" {
  default = null
  type    = string
}

variable "region" {
  default = "us-west-2"
}

variable "kubernetes_version" {
  default = null
}

variable "cni_provider" {
  default = "canal"
}

variable "spot_instances" {
  default = false
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
}

variable "vpc_id" {
  default = null
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