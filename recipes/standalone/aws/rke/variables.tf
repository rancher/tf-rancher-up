variable "prefix" {}

# variable "aws_access_key" {}

# variable "aws_secret_key" {}

# variable "aws_session_token" {}

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
  default = null
}

variable "ssh_key_pair_name" {
  default = null
}

variable "ssh_private_key_path" {
  default = null
}

variable "ssh_public_key_path" {
  default = null
}

variable "create_vpc" {
  default = null
}

# variable "vpc_ip_cidr_range" {}

# variable "vpc_id" {}

# variable "subnet_id" {}

# variable "create_security_group" {}

variable "instance_count" {}

# variable "instance_type" {}

# variable "spot_instances" {}

# variable "instance_disk_size" {}

# variable "instance_security_group_id" {}

variable "ssh_username" {}

variable "user_data" {
  description = "User data content for EC2 instance(s)"
  default     = null
}

#variable "bastion_host" {
#  type = object({
#    address      = string
#    user         = string
#    ssh_key      = string
#    ssh_key_path = string
#  })
#  default     = null
#  description = "Bastion host configuration to access the instances"
#}

# variable "iam_instance_profile" {}

# variable "tags" {}

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

# variable "kubernetes_version" {}

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