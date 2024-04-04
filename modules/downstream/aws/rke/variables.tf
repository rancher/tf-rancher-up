variable "cluster_name" {
  default = "test-rke-ds"
}

variable "creds_name" {
  default = "creds_aws"
  type = string
}

variable "subnet_id" {
  type = string
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

variable "master_hostname_prefix" {
  type    = string
  default = "tf-master"
}

variable "worker_hostname_prefix" {
  type    = string
  default = "tf-worker"
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

variable "node_template_name" {
  default = "example_template"
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
  default = "us-west-2" # Replace with your desired AWS region
}

variable "rke_kubernetes_version" {
  default = "v1.24.17-rancher1-1"
}

variable "master_node_pool_name" {
  default = "master-test"
}

variable "worker_node_pool_name" {
  default = "worker-test"
}

variable "aws_instance_type" {
  default = "t2.medium" # Replace with your desired instance type
}

variable "aws_instance_size" {
  default = 10 # Replace with your desired instance size (in GB)
}

variable "aws_vpc_id" {
  default = "your-vpc-id" # Replace with your VPC ID
}

variable "aws_security_group_name" {
  default = "your-security-group-id" # Replace with your security group ID
}

variable "ssh_user" {
  default = null
  type    = string
}

variable "ami" {
  default = "ami-xxxxxxxxxxxxxxxx" # Replace with your desired AMI ID
}
