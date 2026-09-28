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
  description = "vSphere compute cluster name (uses default resource pool). Specify one: cluster, host, or resource_pool."
  default     = null
}

variable "vsphere_host" {
  type        = string
  description = "vSphere ESXi host (standalone host setup). Specify one: cluster, host, or resource_pool."
  default     = null
}

variable "vsphere_resource_pool" {
  type        = string
  description = "vSphere resource pool (full path like 'cluster1/Resources/mypool'). Specify one: cluster, host, or resource_pool."
  default     = null
}

variable "vsphere_folder" {
  type        = string
  description = "vSphere folder for VM placement (e.g., 'my-folder' or 'parent/child-folder'). Optional."
  default     = null
}

variable "vsphere_network" {
  type        = string
  description = "vSphere network name"
}

variable "vsphere_firmware" {
  type        = string
  description = "Firmware for the VM (bios or efi). Defaults to template value for clone path, OVA value for OVF path."
  default     = null
}

# ── vCenter clone path (use_ovf_deploy = false, default) ─────────────────────
variable "vsphere_virtual_machine" {
  type        = string
  description = "VM template name in vCenter (must have cloud-init support). Required when use_ovf_deploy = false."
  default     = null
}

# ── Standalone ESXi / OVF deploy path (use_ovf_deploy = true) ────────────────
variable "use_ovf_deploy" {
  type        = bool
  description = "Deploy VMs from an OVA/OVF file instead of cloning a vCenter template. Use this for standalone ESXi hosts without vCenter. When true, ova_url is required and vsphere_virtual_machine is ignored."
  default     = false
}

variable "network_adapter_type" {
  type        = string
  description = "Network adapter type for OVF deploy path. Ignored when use_ovf_deploy = false (adapter type comes from the vCenter template). Standard cloud images (Ubuntu, RHEL) use vmxnet3."
  default     = "vmxnet3"
}

variable "ova_url" {
  type        = string
  description = "URL or local path to the OVA/OVF to deploy. Required when use_ovf_deploy = true. Supports https:// (fetched at deploy time, no pre-download needed) or file:/// (local path, faster for repeated testing). Example: https://cloud-images.ubuntu.com/releases/noble/release/ubuntu-24.04-server-cloudimg-amd64.ova"
  default     = null
}

# Static IP Configuration (OVF path only — clone path uses template network settings)
variable "ip_addresses" {
  type        = list(string)
  description = "Static IPv4 addresses in CIDR form (e.g. '10.5.105.105/22'), one per instance matched by index. Leave empty for DHCP. Only used when use_ovf_deploy = true."
  default     = []
}

variable "ip_gateway" {
  type        = string
  description = "Default gateway for static IP configuration. Only used when use_ovf_deploy = true."
  default     = null
}

variable "dns_servers" {
  type        = list(string)
  description = "DNS servers for static IP configuration. Only used when use_ovf_deploy = true."
  default     = ["1.1.1.1", "8.8.8.8"]
}

# VM Configuration
variable "prefix" {
  type        = string
  description = "Prefix for VM naming"
}

variable "start_index" {
  type        = number
  description = "Starting index for VM naming (e.g., 1 for cp-1, 2 for cp-2)"
  default     = 1
}

variable "instance_count" {
  type        = number
  description = "Number of VMs to create"
  default     = 1
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
  description = "Root disk size in GB. For clone path: sets disk size directly. For OVF path: resizes the OVA's native disk to this size after deploy."
  default     = 100
}

# SSH Configuration
variable "vm_username" {
  type        = string
  description = "SSH username for VM access"
  default     = "ubuntu"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for VM access"
}

variable "ssh_private_key_path" {
  type        = string
  description = "Path to SSH private key (used if ssh_private_key is not provided)"
  default     = null
}

variable "ssh_private_key" {
  type        = string
  description = "SSH private key content (takes precedence over ssh_private_key_path)"
  default     = null
  sensitive   = true
}

variable "create_ssh_key_pair" {
  type        = bool
  description = "Create new SSH key pair"
  default     = false
}

# Cloud-Init Configuration
variable "user_data" {
  type        = string
  description = "Cloud-init user data (YAML). If null, uses default template."
  default     = null
}

# Dependency Management
variable "dependency" {
  description = "Optional dependency from another resource"
  default     = null
}
