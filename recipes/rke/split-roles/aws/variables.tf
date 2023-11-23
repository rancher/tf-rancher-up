variable "aws_access_key" {
  type        = string
  description = "Enter your AWS access key"
}

variable "aws_secret_key" {
  type        = string
  description = "Enter your AWS secret key"
  sensitive   = true
}

variable "aws_region" {
  type        = string
  description = "AWS region used for all resources"
}

variable "vpc_zone" {
  type        = string
  description = "VPC zone"
  default     = null
}

variable "subnet_id" {
  type        = string
  description = "VPC Subnet ID to create the instance(s) in"
  default     = null
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to create the instance(s) in"
  default     = null
}

variable "create_security_group" {
  type        = bool
  description = "Should create the security group associated with the instance(s)"
  default     = true
}

# TODO: Add a check based on above value
variable "instance_security_group" {
  type        = string
  description = "Provide a pre-existing security group ID"
  default     = null
}

variable "instance_security_group_name" {
  type        = string
  description = "Provide a pre-existing security group name"
  default     = null
}

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = null
}

variable "master_nodes_count" {
  type        = number
  description = "Number of master nodes to create"
  default     = 1
}

variable "worker_nodes_count" {
  type        = number
  description = "Number of worker nodes to create"
  default     = 1
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

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version to use for the RKE cluster"
  default     = null
}

variable "install_docker" {
  type        = bool
  description = "Should install docker while creating the instance"
  default     = true
}

variable "docker_version" {
  type        = string
  description = "Docker version to install on nodes"
  default     = "23.0.6"
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

variable "ssh_username" {
  type        = string
  description = "Username used for SSH with sudo access"
  default     = "ubuntu"
}

variable "master_nodes_instance_type" {
  type        = string
  description = "Instance type used for all master nodes"
  default     = "t3.medium"
}

variable "master_nodes_instance_disk_size" {
  type        = string
  description = "Disk size used for all master nodes (in GB)"
  default     = "80"
}

variable "worker_nodes_instance_type" {
  type        = string
  description = "Instance type used for all worker nodes"
  default     = "t3.large"
}

variable "worker_nodes_instance_disk_size" {
  type        = string
  description = "Disk size used for all worker nodes (in GB)"
  default     = "80"
}
