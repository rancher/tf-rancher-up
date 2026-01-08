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
}

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = "rancher-terraform"
}

variable "tag_begin" {
  type        = number
  description = "When module is being called mode than once, begin tagging from this number"
  default     = 1
}

variable "instance_type" {
  type        = string
  description = "Instance type used for all EC2 instances"
  default     = "t3.medium"
  nullable    = false
}

variable "instance_disk_size" {
  type        = string
  description = "Specify root disk size (GB)"
  default     = "80"
  nullable    = false
}

variable "instance_count" {
  type        = number
  description = "Number of EC2 instances to create"
  default     = 0
  nullable    = false
}

variable "instance_ami" {
  type        = string
  description = "Override the default SLES or Ubuntu AMI"
  default     = null
}

variable "os_type" {
  type        = string
  description = "Use SLES or Ubuntu images when launching instances (sles or ubuntu)"
  default     = "sles"
  validation {
    condition     = contains(["sles", "ubuntu"], var.os_type)
    error_message = "The operating system type must be 'sles' or 'ubuntu'."
  }
}

variable "sles_version" {
  description = "Version of SLES to use for instances (ex: 15-sp6)"
  default     = "15-sp6"
}

variable "ubuntu_version" {
  description = "Version of Ubuntu to use for instances (ex: 22.04)"
  default     = "22.04"
}

variable "subnet_id" {
  type        = any
  description = "VPC Subnet ID to create the instance(s) in"
  default     = null
}

variable "create_ssh_key_pair" {
  type        = bool
  description = "Specify if a new SSH key pair needs to be created for the instances"
  default     = true
  nullable    = false
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

# Used in CI/CD as we don't store the SSH key local. It would read from a secret and
# the contents are passed on directly. Used when create_ssh_key_pair is false and
# ssh_key_pair_name is null
variable "ssh_key" {
  type        = string
  description = "Contents of the private key to connect to the instances."
  default     = null
  sensitive   = true
}

variable "ssh_private_key_path" {
  type        = string
  description = "Path to write the generated SSH private key"
  default     = null
}

variable "create_security_group" {
  type        = bool
  description = "Create the security group attached to the instance(s)"
  default     = true
}

variable "instance_security_group" {
  type        = string
  description = "Provide a pre-existing security group ID to attach to the instance(s)"
  default     = null
  validation {
    condition     = var.create_security_group && var.instance_security_group == null || !var.create_security_group && var.instance_security_group != null
    error_message = "Both create_security_group and instance_security_group can't be set, choose either option. If creating a VPC the SG must be created"
  }
}

variable "restricted_access" {
  type        = bool
  description = "Restrict access to SSH and kube-apiserver ports when creating the security group, allowing only the public IP of the client running terraform"
  default     = false
}

variable "ssh_username" {
  type        = string
  description = "Username used for SSH with sudo access"
  default     = null
  validation {
    condition     = var.ssh_username != null
    error_message = "An SSH username must be provided"
  }
}

variable "spot_instances" {
  type        = bool
  description = "Use spot instances"
  default     = false
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

variable "create_vpc" {
  description = "Create a VPC"
  default     = false
}

variable "vpc_cidr" {
  description = "CIDR for AWS VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Create Public subnets for VPC"
  default     = true
}

variable "private_subnets" {
  description = "Create Public subnets for VPC"
  default     = null
}

variable "tags" {
  description = "User-provided tags for the resources"
  type        = map(string)
  default     = {}
}
