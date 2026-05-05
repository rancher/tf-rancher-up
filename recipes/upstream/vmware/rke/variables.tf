# General Variables
variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = "rke-vmware"
}

# vSphere Variables
variable "vsphere_server" {
  description = "vSphere server FQDN or IP"
  type        = string
}

variable "vsphere_user" {
  description = "vSphere username"
  type        = string
}

variable "vsphere_password" {
  description = "vSphere password"
  type        = string
  sensitive   = true
}

variable "vsphere_datacenter" {
  description = "vSphere datacenter name"
  type        = string
}

variable "vsphere_datastore" {
  description = "vSphere datastore name"
  type        = string
}

variable "vsphere_cluster" {
  description = "vSphere cluster name (optional if host is specified)"
  type        = string
  default     = null
}

variable "vsphere_host" {
  description = "vSphere host name (optional if cluster is specified)"
  type        = string
  default     = null
}

variable "vsphere_resource_pool" {
  description = "vSphere resource pool name or path"
  type        = string
  default     = null
}

variable "vsphere_folder" {
  description = "vSphere folder to place VMs in"
  type        = string
  default     = null
}

variable "vsphere_network" {
  description = "vSphere network name"
  type        = string
}

variable "vsphere_virtual_machine" {
  description = "vSphere VM template name"
  type        = string
}

variable "vsphere_allow_unverified_ssl" {
  description = "Allow unverified SSL for vSphere"
  type        = bool
  default     = true
}

# VM Variables
variable "instance_count" {
  type        = number
  description = "Number of instances to create"
  default     = 3
}

variable "vm_cpus" {
  description = "Number of CPUs for the VMs"
  type        = number
  default     = 4
}

variable "vm_memory" {
  description = "Memory for the VMs in MB"
  type        = number
  default     = 8192
}

variable "vm_disk" {
  description = "Disk size for the VMs in GB"
  type        = number
  default     = 80
}

variable "vm_username" {
  description = "Username for the VMs"
  type        = string
  default     = "ubuntu"
}

# SSH Variables
variable "ssh_public_key_path" {
  description = "Path to the SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_private_key_path" {
  description = "Path to the SSH private key"
  type        = string
  default     = "~/.ssh/id_rsa"
}

variable "create_ssh_key_pair" {
  description = "Create a new SSH key pair"
  type        = bool
  default     = true
}

# RKE Variables
variable "kubernetes_version" {
  description = "Kubernetes version for RKE"
  type        = string
  default     = null
}

# Kubeconfig Variables
variable "kube_config_path" {
  description = "Path to save the kubeconfig file"
  type        = string
  default     = null
}

# Rancher Variables
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
  default     = "v2.10.1"
}

variable "rancher_replicas" {
  description = "Number of Rancher replicas"
  type        = number
  default     = 3
}

variable "rancher_helm_repository" {
  description = "Rancher helm repository"
  type        = string
  default     = "https://releases.rancher.com/server-charts/latest"
}

variable "rancher_helm_repository_username" {
  description = "Rancher helm repository username"
  type        = string
  default     = null
}

variable "rancher_helm_repository_password" {
  description = "Rancher helm repository password"
  type        = string
  default     = null
  sensitive   = true
}

variable "cert_manager_helm_repository" {
  description = "Cert-manager helm repository"
  type        = string
  default     = "https://charts.jetstack.io"
}

variable "cert_manager_helm_repository_username" {
  description = "Cert-manager helm repository username"
  type        = string
  default     = null
}

variable "cert_manager_helm_repository_password" {
  description = "Cert-manager helm repository password"
  type        = string
  default     = null
  sensitive   = true
}

variable "wait" {
  description = "An optional wait before installing the Rancher helm chart (seconds)"
  type        = number
  default     = 60
}

variable "helm_timeout" {
  description = "Timeout for helm operations"
  type        = number
  default     = 600
}