variable "do_token" {
  type        = string
  description = "DigitalOcean Authentication Token"
  default     = null
  sensitive   = true
}

variable "server_instance_count" {
  description = "The number of Server nodes"
  type        = number
  default     = 3

  validation {
    condition = contains([
      1,
      3,
      5,
    ], var.server_instance_count)
    error_message = "Invalid number of Server nodes specified! The value must be 1, 3 or 5 (ETCD quorum)."
  }
}

variable "worker_instance_count" {
  description = "The number of Worker nodes"
  type        = number
  default     = 1

  validation {
    condition     = var.worker_instance_count >= 1
    error_message = "Invalid number of Worker nodes specified. The value must be 1 or more"
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
  description = "Prefix added to names of all resources"
  default     = "rancher-terraform"
}

variable "tag_begin" {
  type        = string
  description = "tag number added to DigitalOcean droplet"
  default     = 2
}

variable "create_ssh_key_pair" {
  type        = bool
  description = "Specify if a new SSH key pair needs to be created for the instances"
  default     = true
  nullable    = false
}

variable "ssh_key_pair_name" {
  type        = string
  description = "Specify the SSH key name to use (that's already present in DigitalOcean)"
  default     = null
}

variable "ssh_key_pair_path" {
  type        = string
  description = "Path to the SSH private key used as the key pair (that's already present in DigitalOcean)"
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

  validation {
    condition = contains([
      "nyc1",
      "nyc3",
      "ams3",
      "sfo2",
      "sfo3",
      "sgp1",
      "lon1",
      "fra1",
      "tor1",
      "blr1",
      "syd1",
    ], var.region)
    error_message = "Invalid Region specified!"
  }
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

variable "k3s_version" {
  description = "Kubernetes version to use for the K3s cluster"
  type        = string
  default     = null
}

variable "k3s_channel" {
  description = "K3s channel to use, the latest patch version for the provided minor version will be used"
  type        = string
  default     = null
}

variable "k3s_token" {
  description = "Token to use when configuring K3s nodes"
  type        = string
  default     = null
}

variable "k3s_config" {
  description = "Additional K3s configuration to add to the config.yaml file"
  type        = string
  default     = null
}

variable "bootstrap_rancher" {
  description = "Bootstrap the Rancher installation"
  type        = bool
  default     = true
}

variable "rancher_hostname" {
  description = "Hostname to set when installing Rancher"
  type        = string
  default     = "rancher"
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
  description = "Rancher ingressClassName value"
  type        = string
  default     = "traefik"
}

variable "rancher_service_type" {
  description = "Rancher serviceType value"
  type        = string
  default     = "ClusterIP"
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
