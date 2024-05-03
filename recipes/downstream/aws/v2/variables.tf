variable "cluster_name" {
  description = "The cluster name"
  default     = "v2-ds"
}

variable "rancher_token" {
  description = "Rancher API token"
  default     = null
  type        = string
}

variable "rancher_insecure" {
  description = "Allow insecure connections to Rancher"
  default     = true
}

variable "rancher_url" {
  description = "The Rancher server URL"
  default     = null
  type        = string
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

variable "zone" {
  description = "AWS zone to use for all resources"
  type        = string
  default     = "a"
}

variable "cloud_credential_id" {
  description = "Rancher cloud credential to use, instead of AWS access/secret key (ex: cattle-global-data:cc-xxx)"
  default     = null
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for all resources"
  default     = null
  type        = string
}

variable "cp_count" {
  description = "Control plane pool node count"
  default     = 1
  type        = number
}

variable "worker_count" {
  description = "Worker pool node count"
  default     = 1
  type        = number
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version to use for the RKE2/k3s cluster"
  default     = null
}

variable "cp_node_pool_name" {
  description = "Control plane pool name"
  default     = "cp"
}

variable "worker_node_pool_name" {
  description = "Worker pool name"
  default     = "w"
}

variable "instance_type" {
  type        = string
  description = "Instance type used for all EC2 instances"
  default     = "t3a.medium"
}

variable "volume_size" {
  description = "Specify root volume size (GB)"
  default     = 20
  type        = number
}

variable "cni_provider" {
  description = "CNI provider to use"
  default     = "calico"
}

variable "vpc_id" {
  description = "AWS VPC to use, subnet ID and security group must exist in the VPC"
  default     = null
  type        = string
}

variable "security_group_name" {
  description = "Security Group name for nodes"
  default     = null
}

variable "ssh_user" {
  type        = string
  description = "Username used for SSH with sudo access"
  default     = "ubuntu"
}

variable "spot_instances" {
  type        = bool
  description = "Use spot instances"
  default     = null
}

variable "ami" {
  default     = null
  description = "AMI to use when launching nodes"

  validation {
    condition     = can(regex("^ami-[[:alnum:]]{10}", var.ami))
    error_message = "The ami value must be a valid AMI id, starting with \"ami-\"."
  }
}
