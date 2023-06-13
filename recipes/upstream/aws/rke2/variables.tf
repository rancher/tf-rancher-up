variable "aws_access_key" {
  type        = string
  description = "AWS access key used to create infrastructure"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS secret key used to create AWS infrastructure"
}

variable "aws_region" {
  type        = string
  description = "AWS region used for all resources"
}

# Required
variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
}

#variable "kubeconfig_file" {
#  description = "The kubeconfig to use to interact with the cluster"
#  default     = "~/.kube/config"
#  type        = string
#}

variable "instance_count" {
  type        = number
  description = "Number of EC2 instances to create"
  default     = 3
}

variable "node_username" {
  type        = string
  default     = "ubuntu"
  description = "node username"
}

variable "instance_ssh_key_name" {
  type        = string
  description = "Specify the SSH key name to use (that's already present in AWS)"
  default     = ""
}

variable "rancher_kubernetes_version" {
  type        = string
  description = "specify the kubernetes version"
}

variable "rke2_token" {
  type    = string
  default = "demo"
}

# TODO: Add a check for existence
variable "ssh_private_key_path" {
 type = string
}

variable "kube_config_path" {
  description = "The path to write the kubeconfig for the RKE cluster"
  type        = string
  default     = null
}
variable "rancher_password" {
  description = "Password to use for bootstrapping Rancher (min 12 characters)"
  default     = "initial-admin-password"
  type        = string
}

variable "rancher_version" {
  description = "Rancher version to install"
  default     = null
  type        = string
}

variable "create_ssh_key_pair" {
  type        = bool
  description = "Specify if a new SSH key pair needs to be created for the instances"
  default     = false
}

variable "ssh_key_pair_name" {
  type        = string
  description = "Specify the SSH key name to use (that's already present in AWS)"
  default     = null
}

variable "ssh_key_pair_path" {
  type        = string
  description = "Path to the SSH private key used as the key pair (that's already present in AWS)"
  default     = null
}

