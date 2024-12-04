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

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = null
}

variable "instance_count" {
  type        = number
  description = "Number of EC2 instances to create"
  default     = null
}

variable "instance_type" {
  type        = string
  description = "Instance type used for all EC2 instances"
  default     = null
}

variable "instance_disk_size" {
  type        = string
  description = "Specify root disk size (GB)"
  default     = null
}

variable "rke2_version" {
  type        = string
  description = "Kubernetes version to use for the RKE2 cluster"
  default     = null
}

variable "rke2_token" {
  description = "Token to use when configuring RKE2 nodes"
  default     = null
}

variable "rke2_config" {
  description = "Additional RKE2 configuration to add to the config.yaml file"
  default     = null
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

variable "rancher_bootstrap_password" {
  description = "Password to use when bootstrapping Rancher (min 12 characters)"
  default     = "initial-bootstrap-password"
  type        = string

  validation {
    condition     = length(var.rancher_bootstrap_password) >= 12
    error_message = "The password provided for Rancher (rancher_bootstrap_password) must be at least 12 characters"
  }
}

variable "rancher_password" {
  description = "Password for the Rancher admin account (min 12 characters)"
  default     = null
  type        = string

  validation {
    condition     = length(var.rancher_password) >= 12
    error_message = "The password provided for Rancher (rancher_password) must be at least 12 characters"
  }
}

variable "rancher_version" {
  description = "Rancher version to install"
  default     = null
  type        = string
}

variable "rancher_replicas" {
  description = "Value for replicas when installing the Rancher helm chart"
  default     = 3
  type        = number
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

variable "create_ssh_key_pair" {
  type        = bool
  description = "Specify if a new SSH key pair needs to be created for the instances"
  default     = null
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

variable "spot_instances" {
  type        = bool
  description = "Use spot instances"
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
  default     = null
}

# TODO: Add a check based on above value
variable "instance_security_group" {
  type        = string
  description = "Provide a pre-existing security group ID"
  default     = null
}

variable "wait" {
  description = "An optional wait before installing the Rancher helm chart"
  default     = "20s"
}
