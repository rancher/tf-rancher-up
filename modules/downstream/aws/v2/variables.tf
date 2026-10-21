variable "cluster_name" {
  type        = string
  description = "The cluster name"
  default     = "v2-ds"
}

variable "rancher_token" {
  sensitive   = true
  description = "Rancher API token"
  default     = null
  type        = string
}

variable "rancher_insecure" {
  type        = bool
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
  sensitive   = true
  type        = string
  description = "AWS secret key used to create AWS infrastructure"
  default     = null
}

variable "aws_region" {
  type        = string
  description = "AWS region used for all resources"
  default     = "us-west-2"
}

variable "zone" {
  description = "AWS availability zone suffix (e.g. a, b, c). Also used as the default zone for machine pools that do not set one"
  type        = string
  default     = "a"
}

variable "cloud_credential_id" {
  description = "Rancher cloud credential to use, instead of AWS access/secret key (ex: cattle-global-data:cc-xxx)"
  default     = null
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for all resources. Also used as the default subnet for machine pools that do not set one"
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
  type        = string
  description = "Control plane pool name"
  default     = "cp"
}

variable "worker_node_pool_name" {
  type        = string
  description = "Worker pool name"
  default     = "w"
}

variable "machine_pools" {
  description = "Optional list of machine pools. When set, overrides the legacy cp_*/worker_* pool configuration. Each pool creates its own machine config, allowing per-pool placement and sizing"
  default     = null
  type = list(object({
    name                = string
    roles               = list(string)
    count               = optional(number, 1)
    drain_before_delete = optional(bool, true)
    zone                = optional(string, null)
    subnet_id           = optional(string, null)
    instance_type       = optional(string, null)
    volume_size         = optional(number, null)
    volume_type         = optional(string, null)
    spot_instances      = optional(bool, false)
  }))

  validation {
    condition     = var.machine_pools == null ? true : length(var.machine_pools) == length(distinct([for pool in var.machine_pools : pool.name]))
    error_message = "Machine pool names must be unique."
  }

  validation {
    condition     = var.machine_pools == null ? true : alltrue([for pool in var.machine_pools : can(regex("^[a-z0-9]([-a-z0-9]{0,48}[a-z0-9])?$", pool.name))])
    error_message = "Machine pool names must be lowercase DNS labels containing only letters, digits, and '-'."
  }

  validation {
    condition = var.machine_pools == null ? true : alltrue([
      for pool in var.machine_pools : length(pool.roles) > 0 && alltrue([
        for role in pool.roles : contains(["etcd", "controlplane", "worker"], role)
      ])
    ])
    error_message = "Each machine pool must declare at least one role. Valid roles are 'etcd', 'controlplane', and 'worker'."
  }

  validation {
    condition     = var.machine_pools == null ? true : alltrue([for pool in var.machine_pools : pool.count >= 1])
    error_message = "Each machine pool count must be at least 1."
  }

  validation {
    condition     = var.machine_pools == null ? true : alltrue([for pool in var.machine_pools : pool.volume_size == null || pool.volume_size > 0])
    error_message = "Machine pool volume_size must be greater than 0 when set."
  }
}

variable "instance_type" {
  type        = string
  description = "Instance type used for EC2 instances. Also used as the default for machine pools that do not set one"
  default     = "t3a.medium"
}

variable "volume_size" {
  description = "Specify root volume size (GB). Also used as the default for machine pools that do not set one"
  default     = 20
  type        = number
}

variable "volume_type" {
  description = "Specify volume type. Also used as the default for machine pools that do not set one"
  default     = "gp3"
  type        = string
}

variable "cni_provider" {
  type        = string
  description = "CNI provider to use"
  default     = "calico"
}

variable "rke2_ingress" {
  type        = string
  description = "RKE2 ingress deployed (ingress-nginx or traefik)"
  default     = "traefik"
}

variable "vpc_id" {
  description = "AWS VPC to use, subnet ID and security group must exist in the VPC"
  default     = null
  type        = string
}

variable "security_group_name" {
  type        = string
  description = "Security Group name for nodes"
  default     = null
}

variable "ssh_user" {
  type        = string
  description = "Username used for SSH with sudo access"
  default     = null
}

variable "ami" {
  type        = string
  default     = null
  description = "AMI to use when launching nodes"

  validation {
    condition     = var.ami == null ? true : can(regex("^ami-[[:alnum:]]{10}", var.ami))
    error_message = "The ami value must be a valid AMI id, starting with \"ami-\"."
  }
}
variable "os_type" {
  type        = string
  description = "Use SLES or Ubuntu images when launching instances (sles or ubuntu)"
  default     = "ubuntu"
  validation {
    condition     = contains(["sles", "ubuntu"], var.os_type)
    error_message = "The operating system type must be 'sles' or 'ubuntu'."
  }
}

variable "sles_version" {
  type        = string
  description = "Version of SLES to use for instances (ex: 15-sp6)"
  default     = "15-sp7"
  nullable    = false
}

variable "ubuntu_version" {
  type        = string
  description = "Version of Ubuntu to use for instances (ex: 22.04)"
  default     = "24.04"
  nullable    = false
}

variable "cp_spot_instances" {
  type        = bool
  description = "Use spot instances for control plane nodes"
  default     = false
}

variable "worker_spot_instances" {
  type        = bool
  description = "Use spot instances for worker nodes"
  default     = false
}