variable "do_token" {
  type        = string
  description = "DigitalOcean Authentication Token"
  nullable    = false
  sensitive   = true
}

variable "droplet_count" {
  type        = number
  description = "Number of droplets to create. Every node runs etcd, so use 1 or an odd number (3, 5) for HA"
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
  nullable    = false
}

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources. Must be unique in the DigitalOcean account (VPC names are account-wide) and a valid DNS label, as it becomes part of the Kubernetes node names"
  default     = "rancher-terraform"
  nullable    = false
  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]{0,48}[a-z0-9])?$", var.prefix))
    error_message = "prefix must be lowercase alphanumeric or '-', start and end with an alphanumeric, and be at most 50 characters."
  }
}

variable "tag_begin" {
  type        = number
  description = "tag number added to DigitalOcean droplet"
  default     = 2
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
  nullable    = false
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

variable "rke2_version" {
  description = "Kubernetes version to use for the RKE2 cluster"
  type        = string
  default     = null
}

variable "rke2_token" {
  sensitive   = true
  description = "Token to use when configuring RKE2 nodes"
  type        = string
  default     = null
}

variable "rke2_config" {
  description = "Additional RKE2 configuration to add to the config.yaml file"
  type        = string
  default     = null
}

variable "bootstrap_rancher" {
  description = "Bootstrap the Rancher installation"
  type        = bool
  default     = true
}

variable "rancher_hostname" {
  description = "Hostname prefix for Rancher; the full hostname is <rancher_hostname>.<first node public IP>.sslip.io"
  type        = string
  default     = "rancher"
  nullable    = false
}

variable "rancher_bootstrap_password" {
  sensitive   = true
  description = "Password to use when bootstrapping Rancher (min 12 characters)"
  default     = "initial-bootstrap-password"
  type        = string
  validation {
    condition     = var.rancher_bootstrap_password == null ? true : length(var.rancher_bootstrap_password) >= 12
    error_message = "The password provided for Rancher (rancher_bootstrap_password) must be at least 12 characters"
  }
}

variable "rancher_password" {
  sensitive   = true
  description = "Password for the Rancher admin account (min 12 characters)"
  type        = string
  validation {
    condition     = var.rancher_password == null ? true : length(var.rancher_password) >= 12
    error_message = "The password provided for Rancher (rancher_password) must be at least 12 characters"
  }
}

variable "rancher_version" {
  description = "Rancher version to install"
  default     = null
  type        = string
}

variable "rancher_ingress_class_name" {
  description = "Rancher ingressClassName value. Defaults to the class of the ingress selected by rke2_ingress"
  type        = string
  default     = null
}

variable "rancher_additional_helm_values" {
  description = "Extra Rancher helm values, one \"key: value\" string each (e.g. \"replicas: 3\")"
  type        = list(string)
  default     = []
  nullable    = false
  validation {
    condition     = alltrue([for v in var.rancher_additional_helm_values : can(regex("^[^:=]+:", v))])
    error_message = "Each entry must use the \"key: value\" format, e.g. \"replicas: 3\"."
  }
}

variable "rancher_service_type" {
  description = "Rancher serviceType value"
  type        = string
  default     = "ClusterIP"
}

variable "waiting_time" {
  type        = string
  description = "An optional wait before installing the Rancher helm chart"
  default     = "20s"
}

variable "create_k8s_api_loadbalancer" {
  type        = bool
  description = "Specify if a loadbalancer for port 6443 needs to be created for the instances"
  default     = false
  nullable    = false
}

variable "create_https_loadbalancer" {
  type        = bool
  description = "Specify if a loadbalancer for port 443 needs to be created for the instances"
  default     = false
  nullable    = false
}

variable "create_firewall" {
  type        = bool
  description = "Specify if a firewall to access droplets needs to be created for the instances"
  default     = true
  nullable    = false
}

variable "droplet_image" {
  type        = string
  description = "name of the OpenSUSE custom image uploaded to DigitalOcean account"
  default     = "openSUSE-Leap-15.6"
  nullable    = false
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
  sensitive   = true
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
  sensitive   = true
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

variable "private_network_interface" {
  description = "Droplet interface attached to the VPC; Canal's overlay network is pinned to it"
  type        = string
  default     = "eth1"
  nullable    = false
}
