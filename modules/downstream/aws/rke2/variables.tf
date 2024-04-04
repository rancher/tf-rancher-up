variable "cluster_name" {
  default = "my-test-cluster"
}

variable "creds_name" {
  default = "creds_aws"
  type = string
}

variable "subnet_id" {
  type    = string
  default = null
}

variable "master_quantity" {
  default = 1
  type    = number
}

variable "worker_quantity" {
  default = 1
  type    = number
}

variable "vpc_zone" {
  type    = string
  default = null
}


variable "rancher_api_key" {
  default = null
  type    = string
}

variable "rancher_secret_key" {
  default = null
  type    = string
}

variable "rancher_api_secret" {
  default = null
  type    = string
}

variable "rancher_url" {
  default = null
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

variable "aws_region" {
  default = "us-west-2"
}

variable "rke2_kubernetes_version" {
  default = "v1.25.16+rke2r1"
}

variable "master_pool_name" {
  default = "mastertf"
}

variable "worker_pool_name" {
  default = "workertf"
}

variable "aws_instance_type" {
  default = "t2.medium"
}

variable "instance_disk_size" {
  default = 10
  type    = number
}

variable "vpc_id" {
  default = null
  type    = string
}

variable "aws_security_group_name" {
  default = "null"
  type    = string
}

variable "ssh_user" {
  default = null
  type    = string
}

variable "ami" {
  default = "ami-xxxxxxxxxxxxxxxx"
}
