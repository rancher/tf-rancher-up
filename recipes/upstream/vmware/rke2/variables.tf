# vSphere Connection

variable "vsphere_server" {
  type        = string
  description = "vSphere server hostname or IP"
}

variable "vsphere_user" {
  type        = string
  description = "vSphere username"
  sensitive   = true
}

variable "vsphere_password" {
  type        = string
  description = "vSphere password"
  sensitive   = true
}

variable "vsphere_allow_unverified_ssl" {
  type        = bool
  description = "Allow unverified SSL certificates"
  default     = true
}

# vSphere Resources

variable "vsphere_datacenter" {
  type        = string
  description = "vSphere datacenter name"
}

variable "vsphere_datastore" {
  type        = string
  description = "vSphere datastore for VM storage"
}

variable "vsphere_cluster" {
  type        = string
  description = "vSphere compute cluster name (cluster-based setup)"
  default     = null
}

variable "vsphere_host" {
  type        = string
  description = "vSphere ESXi host FQDN or IP (standalone host setup)"
  default     = null
}

variable "vsphere_resource_pool" {
  type        = string
  description = "vSphere resource pool (alternative to cluster/host - full path)"
  default     = null

  #  validation {
  #    condition     = var.vsphere_cluster != null || var.vsphere_host != null || var.vsphere_resource_pool != null
  #    error_message = "One of vsphere_cluster, vsphere_host, or vsphere_resource_pool must be specified"
  #  }
}

variable "vsphere_folder" {
  type        = string
  description = "vSphere folder for VM placement (optional, e.g., 'snikale-vm-folder')"
  default     = null
}

variable "vsphere_network" {
  type        = string
  description = "vSphere network name"
}

variable "vsphere_virtual_machine" {
  type        = string
  description = "VM template name (must have cloud-init and VMware guestinfo support)"
}

# VM Configuration

variable "prefix" {
  type        = string
  description = "Prefix for resource naming"
}

variable "instance_count" {
  type        = number
  description = "Number of RKE2 server nodes (use odd numbers: 1, 3, 5 for HA)"
  default     = 3

  validation {
    condition     = var.instance_count >= 1
    error_message = "instance_count must be at least 1"
  }
}

variable "vm_cpus" {
  type        = number
  description = "Number of vCPUs per VM"
  default     = 4
}

variable "vm_memory" {
  type        = number
  description = "Memory in MB per VM"
  default     = 8192
}

variable "vm_disk" {
  type        = number
  description = "Disk size in GB"
  default     = 100
}

# SSH Configuration

variable "vm_username" {
  type        = string
  description = "SSH username for VM access"
  default     = "ubuntu"
}

variable "ssh_public_key_path" {
  type        = string
  description = "Path to SSH public key for VM access"
  default     = null
}

variable "ssh_private_key_path" {
  type        = string
  description = "Path to SSH private key (required if create_ssh_key_pair is false)"
  default     = null
}

variable "create_ssh_key_pair" {
  type        = bool
  description = "Create new SSH key pair (if true, ssh_private_key_path is ignored)"
  default     = true
}

# RKE2 Configuration

variable "rke2_version" {
  type        = string
  description = "RKE2 version (e.g., v1.28.5+rke2r1). Leave null for latest."
  default     = null
}

variable "rke2_token" {
  type        = string
  description = "RKE2 cluster token (auto-generated if null)"
  sensitive   = true
  default     = null
}

variable "rke2_config" {
  type        = string
  description = "Additional RKE2 config.yaml content (YAML format)"
  default     = null
}

variable "rke2_ingress" {
  type        = string
  description = "Ingress controller (nginx, traefik, or ingress-nginx)"
  default     = "nginx"

  validation {
    condition     = contains(["nginx", "traefik", "ingress-nginx"], var.rke2_ingress)
    error_message = "rke2_ingress must be 'nginx', 'traefik', or 'ingress-nginx'"
  }
}

# Rancher Configuration (Optional)



variable "rancher_version" {
  type        = string
  description = "Rancher version to install"
  default     = "v2.13.1"
}

variable "rancher_bootstrap_password" {
  type        = string
  description = "Rancher initial bootstrap password (used for first-time login)"
  sensitive   = true
  default     = "initial-bootstrap-password"
}

variable "rancher_password" {
  type        = string
  description = "Rancher permanent admin password (set after bootstrap)"
  sensitive   = true
  default     = "admin"
}

variable "rancher_replicas" {
  type        = number
  description = "Number of Rancher replicas"
  default     = 3
}

variable "rancher_helm_repository" {
  type        = string
  description = "Rancher Helm repository URL"
  default     = "https://releases.rancher.com/server-charts/stable"
}

variable "rancher_helm_repository_username" {
  type        = string
  description = "Rancher Helm repository username"
  default     = null
}

variable "rancher_helm_repository_password" {
  type        = string
  description = "Rancher Helm repository password"
  sensitive   = true
  default     = null
}

variable "cert_manager_helm_repository" {
  type        = string
  description = "Cert-manager Helm repository URL"
  default     = "https://charts.jetstack.io"
}

variable "cert_manager_helm_repository_username" {
  type        = string
  description = "Cert-manager Helm repository username"
  default     = null
}

variable "cert_manager_helm_repository_password" {
  type        = string
  description = "Cert-manager Helm repository password"
  sensitive   = true
  default     = null
}

variable "wait" {
  type        = number
  description = "Wait before installing Rancher (seconds)"
  default     = 60
}

# Other

variable "kube_config_path" {
  type        = string
  description = "Path to save kubeconfig file"
  default     = null
}

variable "helm_timeout" {
  type        = number
  description = "Timeout in seconds for Helm releases"
  default     = 1800
}

variable "start_index" {
  type        = number
  description = "Starting index for server nodes"
  default     = 1
}
