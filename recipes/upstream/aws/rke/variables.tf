variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = null
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

variable "create_ssh_key_pair" {
  type        = bool
  description = "Specify if a new SSH key pair needs to be created for the instances"
  default     = true
}

variable "ssh_key_pair_name" {
  type        = string
  description = "If you want to use an existing key pair, specify its name"
  default     = null
}

variable "ssh_private_key_path" {
  type        = string
  description = "The full path where is present the pre-generated SSH PRIVATE key (not generated by Terraform)"
  default     = null
}

variable "ssh_public_key_path" {
  description = "The full path where is present the pre-generated SSH PUBLIC key (not generated by Terraform)"
  default     = null
}

variable "create_vpc" {
  type        = bool
  description = "Specify whether VPC / Subnet should be created for the instances"
  default     = true
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to create the instance(s) in"
  default     = null
}

variable "subnet_id" {
  type        = string
  description = "VPC Subnet ID to create the instance(s) in"
  default     = null
}

variable "create_security_group" {
  type        = bool
  description = "Should create the security group associated with the instance(s)"
  default     = true
  nullable    = false
}

variable "instance_count" {
  type        = number
  description = "Number of EC2 instances to create"
  default     = 3
  nullable    = false
}

variable "instance_type" {
  type        = string
  description = "Instance type used for all EC2 instances"
  default     = "t3.medium"
  nullable    = false
}

variable "spot_instances" {
  type        = bool
  description = "Use spot instances"
  default     = false
  nullable    = false
}

variable "instance_disk_size" {
  type        = string
  description = "Specify root disk size (GB)"
  default     = "80"
  nullable    = false
}

variable "instance_security_group_id" {
  type        = string
  description = "Provide a pre-existing security group ID"
  default     = null
}

variable "ssh_username" {
  type        = string
  description = "Username used for SSH with sudo access"
  default     = "ubuntu"
  nullable    = false
}

variable "user_data" {
  description = "User data content for EC2 instance(s)"
  default     = null
}

variable "bastion_host" {
  type = object({
    address      = string
    user         = string
    ssh_key      = string
    ssh_key_path = string
  })
  default     = null
  description = "Bastion host configuration to access the instances"
}

variable "iam_instance_profile" {
  type        = string
  description = "Specify IAM Instance Profile to assign to the instances/nodes"
  default     = null
}

variable "tag_begin" {
  type        = number
  description = "When module is being called more than once, begin tagging from this number"
  default     = 1
}

variable "tags" {
  description = "User-provided tags for the resources"
  type        = map(string)
  default     = {}
}

variable "install_docker" {
  type        = bool
  description = "Install Docker while creating the instances"
  default     = true
}

variable "docker_version" {
  type        = string
  description = "Docker version to install on nodes"
  default     = "20.10"
}

variable "waiting_time" {
  description = "Waiting time (in seconds)"
  default     = 120
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version to use for the RKE cluster"
  default     = null
}

variable "ingress_provider" {
  description = "Ingress controller provider"
  default     = "nginx"
}

variable "bootstrap_rancher" {
  description = "Bootstrap the Rancher installation"
  type        = bool
  default     = true
}

variable "kube_config_path" {
  description = "The path to write the kubeconfig for the RKE cluster"
  type        = string
  default     = null
}

variable "kube_config_filename" {
  description = "Filename to write the kube config"
  type        = string
  default     = null
}

variable "rancher_hostname" {
  description = "Hostname to set when installing Rancher"
  type        = string
  default     = null
}

variable "rancher_password" {
  type = string

  validation {
    condition     = length(var.rancher_password) >= 12
    error_message = "The password must be at least 12 characters."
  }
}

variable "rancher_version" {
  description = "Rancher version to install"
  type        = string
  default     = null
}

variable "rancher_helm_repository" {
  description = "Helm repository for Rancher chart"
  default     = null
  type        = string
}

variable "rancher_helm_repository_username" {
  description = "Private Rancher helm repository username"
  default     = null
  type        = string
}

variable "rancher_helm_repository_password" {
  description = "Private Rancher helm repository password"
  default     = null
  type        = string
}

variable "cert_manager_helm_repository" {
  description = "Helm repository for Cert Manager chart"
  default     = null
  type        = string
}

variable "cert_manager_helm_repository_username" {
  description = "Private Cert Manager helm repository username"
  default     = null
  type        = string
}

variable "cert_manager_helm_repository_password" {
  description = "Private Cert Manager helm repository password"
  default     = null
  type        = string
}