variable "do_token" {
  type        = string
  description = "DigitalOcean Authentication Token"
  nullable    = false
  sensitive   = true
}

variable "cluster_name" {
  type        = string
  description = "The name of the downstream cluster in Rancher"
  default     = "do-downstream"
  nullable    = false
  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]{0,61}[a-z0-9])?$", var.cluster_name))
    error_message = "cluster_name must be a lowercase DNS label (letters, digits, '-')."
  }
}

variable "rancher_api_url" {
  description = "The URL of the upstream Rancher server (e.g. https://rancher.yourdomain.com). When null, it is read from upstream_state_path"
  type        = string
  default     = null
  validation {
    condition     = (var.rancher_api_url == null) == (var.rancher_token_key == null)
    error_message = "Set both rancher_api_url and rancher_token_key, or neither (to read them from upstream_state_path)."
  }
}

variable "rancher_token_key" {
  description = "API token for the upstream Rancher server. When null, it is read from upstream_state_path"
  type        = string
  default     = null
  sensitive   = true
}

variable "upstream_state_path" {
  description = "Path to the terraform.tfstate of the upstream recipe; its rancher_url and rancher_token outputs are used when rancher_api_url is null"
  type        = string
  default     = "../../../upstream/digitalocean/rke2/terraform.tfstate"
  nullable    = false
}

variable "rancher_insecure" {
  description = "Skip TLS verification of the Rancher API (needed for the self-signed certificate of the upstream recipe)"
  type        = bool
  default     = true
  nullable    = false
}

variable "droplet_count" {
  type        = number
  description = "Number of droplets to create. Every node runs all roles (etcd, control plane, worker), so use 1 or an odd number (3, 5)"
  default     = 3
  nullable    = false
  validation {
    condition     = var.droplet_count == 1 || (var.droplet_count >= 3 && var.droplet_count % 2 == 1)
    error_message = "droplet_count must be 1 or an odd number >= 3 so etcd keeps quorum."
  }
}

variable "droplet_size" {
  type        = string
  description = "Size used for all droplets"
  default     = "s-2vcpu-4gb"
}

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources. Must be unique in the DigitalOcean account (VPC names are account-wide) and a valid DNS label, as it becomes part of the Kubernetes node names"
  default     = "rancher-downstream"
  nullable    = false
  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]{0,48}[a-z0-9])?$", var.prefix))
    error_message = "prefix must be lowercase alphanumeric or '-', start and end with an alphanumeric, and be at most 50 characters."
  }
}

variable "tag_begin" {
  type        = number
  description = "tag number added to DigitalOcean droplet"
  default     = 1
}

variable "create_ssh_key_pair" {
  type        = bool
  description = "Specify if a new SSH key pair needs to be created for the instances"
  default     = true
  nullable    = false
  validation {
    condition     = var.create_ssh_key_pair || (var.ssh_key_pair_name != null && var.ssh_key_pair_path != null)
    error_message = "When create_ssh_key_pair is false, set both ssh_key_pair_name (key already in DigitalOcean) and ssh_key_pair_path (its private key, without a passphrase)."
  }
}

variable "ssh_key_pair_name" {
  type        = string
  description = "Specify the SSH key name to use (that's already present in DigitalOcean)"
  default     = null
}

variable "ssh_key_pair_path" {
  type        = string
  description = "Path to the private key of ssh_key_pair_name. Terraform cannot use a passphrase-protected key"
  default     = null
}

variable "ssh_private_key_path" {
  type        = string
  description = "Path to write the generated SSH private key"
  default     = null
}

variable "region" {
  type        = string
  description = "Region that droplets will be deployed to"
  default     = "sfo3"
}

variable "ssh_username" {
  description = "The user account used to connect to droplets via ssh"
  type        = string
  default     = "root"
}

variable "rke2_version" {
  description = "RKE2 version for the cluster; must be one the upstream Rancher offers (Cluster Management > Create > Custom)"
  type        = string
  default     = "v1.36.4+rke2r1"
  nullable    = false
}

variable "create_k8s_api_loadbalancer" {
  type        = bool
  description = "Specify if a loadbalancer for port 6443 needs to be created for the instances"
  default     = false
}

variable "create_https_loadbalancer" {
  type        = bool
  description = "Specify if a loadbalancer for port 443 needs to be created for the instances"
  default     = false
}

variable "create_firewall" {
  type        = bool
  description = "Specify if a firewall to access droplets needs to be created for the instances"
  default     = true
}

variable "droplet_image" {
  type        = string
  description = "name of the OpenSUSE custom image uploaded to DigitalOcean account"
  default     = "openSUSE-Leap-15.6"
}

variable "os_type" {
  description = "Operating system type (opensuse or ubuntu)"
  type        = string
  default     = "opensuse"
  validation {
    condition     = contains(["opensuse", "ubuntu"], var.os_type)
    error_message = "The operating system type must be 'opensuse' or 'ubuntu'."
  }
}

variable "rke2_ingress" {
  description = "RKE2 ingress deployed (nginx or traefik)"
  type        = string
  default     = "nginx"
  validation {
    condition     = contains(["nginx", "traefik"], var.rke2_ingress)
    error_message = "The ingress selected must be 'nginx' or 'traefik'."
  }
}

variable "private_network_interface" {
  description = "Droplet interface attached to the VPC; Canal's overlay network is pinned to it"
  type        = string
  default     = "eth1"
  nullable    = false
}

variable "user_tag" {
  description = "Name of the person deploying, set as the user: tag on every droplet (e.g. \"jdoe\"). Defaults to prefix"
  type        = string
  default     = null
  validation {
    condition     = var.user_tag == null || can(regex("^[A-Za-z0-9_-]+$", var.user_tag))
    error_message = "user_tag may only contain letters, digits, '-' and '_'."
  }
}

variable "kube_audit_level" {
  description = "Kubernetes API audit level on the control-plane nodes: None (disabled), Metadata (who, what, when), Request (+ request bodies) or RequestResponse (+ response bodies). Secrets, ConfigMaps and token reviews are always capped at Metadata"
  type        = string
  default     = "None"
  nullable    = false
  validation {
    condition     = contains(["None", "Metadata", "Request", "RequestResponse"], var.kube_audit_level)
    error_message = "kube_audit_level must be None, Metadata, Request or RequestResponse."
  }
}

variable "kube_audit_policy" {
  description = "Full Kubernetes audit Policy YAML to use instead of the one generated from kube_audit_level"
  type        = string
  default     = null
}

variable "kube_audit_log_max_age" {
  description = "Days to keep rotated Kubernetes audit log files"
  type        = number
  default     = 30
  nullable    = false
}

variable "kube_audit_log_max_backup" {
  description = "Number of rotated Kubernetes audit log files to keep"
  type        = number
  default     = 10
  nullable    = false
}

variable "kube_audit_log_max_size" {
  description = "Size in MB at which the Kubernetes audit log file is rotated"
  type        = number
  default     = 100
  nullable    = false
}

variable "authorized_cluster_endpoint" {
  description = "Authorized Cluster Endpoint (ACE): kubeconfigs downloaded from Rancher get contexts that reach this cluster's API server directly, bypassing Rancher (it keeps working if Rancher is down). Those requests appear only in the Kubernetes audit log (kube_audit_level), never in Rancher's"
  type = object({
    enabled  = bool
    fqdn     = optional(string)
    ca_certs = optional(string)
  })
  default  = { enabled = false }
  nullable = false
}
