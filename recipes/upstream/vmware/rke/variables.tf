variable "vsphere_server" {
  type        = string
  description = "Add the vSphere hostname."
}

variable "vsphere_server_allow_unverified_ssl" {
  type        = bool
  description = "Allow use of unverified SSL certificates (Ex: Self signed)"
}
variable "vsphere_user" {
  type        = string
  description = "Add your vSphere username."
}

variable "vsphere_password" {
  type        = string
  description = "Add your vSphere password for the above mentioned username."
}

variable "instance_count" {
  type        = number
  description = "Number of instances to create"
  default     = 3
}

variable "ssh_private_key_path" {
  type        = string
  description = "Add your SSH private key path here."
}

variable "vsphere_datacenter" {
  type        = string
  description = "vSphere Datacenter details."
}

variable "vsphere_datastore" {
  type        = string
  description = "Datastore used for storing VM data."
}

variable "vsphere_resource_pool" {
  type        = string
  description = "Available resourcepool on the host."
}

variable "vsphere_virtual_machine" {
  type        = string
  description = "Virtual Machine template name"
}

variable "vsphere_network" {
  type = string
}

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
