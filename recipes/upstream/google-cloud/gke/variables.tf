variable "prefix" {}

variable "project_id" {}

variable "gcp_account_json" {
  description = "The full path to the Google Cloud service account JSON key file used for authentication"
  type        = string
  default     = null
}

variable "region" {
  description = "Google Region to create the resources"
  default     = "us-west2"
}

# variable "ip_cidr_range" {}

# variable "vpc" {}

# variable "subnet" {}

# variable "cluster_version_prefix" {}

# variable "instance_count" {}

# variable "instance_disk_size" {}

# variable "disk_type" {}

# variable "image_type" {}

# variable "instance_type" {}

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

variable "waiting_time" {
  description = "Waiting time (in seconds)"
  default     = 120
}

variable "bootstrap_rancher" {
  description = "Bootstrap the Rancher installation"
  type        = bool
  default     = true
}

variable "rancher_hostname" {}

variable "rancher_bootstrap_password" {
  description = "Password to use when bootstrapping Rancher (min 12 characters)"
  default     = "initial-bootstrap-password"
  type        = string
  validation {
    condition     = var.rancher_bootstrap_password == null ? true : length(var.rancher_bootstrap_password) >= 12
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
  type        = string
  default     = null
}
