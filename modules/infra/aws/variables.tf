variable "aws_access_key" {
  type        = string
  description = "AWS access key used to create infrastructure"
  default = ""
}

variable "aws_secret_key" {
  type        = string
  description = "AWS secret key used to create AWS infrastructure"
  default = ""
}

variable "aws_region" {
  type        = string
  description = "AWS region used for all resources"
  default     = "us-east-1"
}

# Required
variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
}

variable "instance_type" {
  type        = string
  description = "Instance type used for all EC2 instances"
  default     = "t3.medium"
}

variable "instance_disk_size" {
  type = string
  description = "Specify root disk size"
  default = "80"
}

variable "instance_count" {
  type    = number
  description = "Number of EC2 instances to create"
  default = 3
}

variable "should_create_ssh_key_pair" {
  type = bool
  description = "Specify if a new temporary SSH key pair needs to be created for the instances"
  default = false
}

# TODO: Add a check based on above value
variable "instance_ssh_key_name" {
  type = string
  description = "Specify the SSH key name to use (that's already present in AWS)"
  default = ""
}

# TODO: Add a check for existence
variable "ssh_private_key_path" {
  default = "~/.ssh/id_rsa"
}

variable "should_install_docker" {
  type = bool
  description = "Should install docker while creating the instance"
  default = true
}

variable "docker_version" {
  type        = string
  description = "Docker version to install on nodes"
  default     = "20.10"
}

variable "should_create_security_group" {
  type = bool
  description = "Should create the security group associated with the instance(s)"
  default = true
}

# TODO: Add a check based on above value
variable "instance_security_group" {
  type = string
  description = "If chosen to not create security group, this should be provided"
  default = ""
}

# Local variables used to reduce repetition
locals {
  node_username = "ubuntu"
}
