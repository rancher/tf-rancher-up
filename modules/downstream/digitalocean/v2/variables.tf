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

variable "do_token" {
  type        = string
  description = "DigitalOcean access token used to create infrastructure"
  default     = null
  sensitive   = true
}

variable "region" {
  type        = string
  description = "DigitalOcean region used for all resources"
  default     = "sfo3"
}

variable "cloud_credential_id" {
  description = "Rancher cloud credential to use, instead of a DigitalOcean access token (ex: cattle-global-data:cc-xxx)"
  default     = null
  type        = string
}

variable "size" {
  type        = string
  description = "Droplet size used for all nodes. Also used as the default for machine pools that do not set one"
  default     = "s-2vcpu-4gb"
}

variable "image" {
  type        = string
  description = "DigitalOcean image slug used for all nodes. Also used as the default for machine pools that do not set one"
  default     = "ubuntu-24-04-x64"
}

variable "ssh_user" {
  type        = string
  description = "Username used for SSH with sudo access"
  default     = "root"
}

variable "ssh_key_fingerprint" {
  type        = string
  description = "SSH key fingerprint registered in DigitalOcean"
  default     = null
}

variable "ssh_key_contents" {
  type        = string
  description = "SSH private key contents used to access the nodes"
  default     = null
  sensitive   = true
}

variable "ssh_port" {
  type        = string
  description = "SSH port used to access the nodes"
  default     = "22"
}

variable "private_networking" {
  type        = bool
  description = "Enable private networking for droplets"
  default     = true
}

variable "ipv6" {
  type        = bool
  description = "Enable IPv6 for droplets"
  default     = false
}

variable "monitoring" {
  type        = bool
  description = "Enable monitoring for droplets"
  default     = false
}

variable "backups" {
  type        = bool
  description = "Enable backups for droplets"
  default     = false
}

variable "tags" {
  type        = string
  description = "Comma-separated list of tags to apply to the droplets"
  default     = null
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
  description = "Optional list of machine pools. When set, replaces the legacy cp_*/worker_* pool configuration. Each pool creates its own machine config, allowing per-pool placement and sizing"
  default     = null
  type = list(object({
    name                = string
    roles               = list(string)
    count               = optional(number, 1)
    drain_before_delete = optional(bool, true)
    region              = optional(string, null)
    size                = optional(string, null)
    image               = optional(string, null)
  }))

  validation {
    condition     = var.machine_pools == null || length(var.machine_pools) > 0
    error_message = "machine_pools must contain at least one pool. Omit the variable to use the legacy cp/worker pools."
  }

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

variable "custom_user_data" {
  type        = string
  description = "Custom user data passed to the machine driver userdata field for v2 clusters. Rancher interprets the value (content is not appended by tf-rancher-up). Default null."
  default     = null
}