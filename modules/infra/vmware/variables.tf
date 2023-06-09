variable "vsphere_datacenter" {
  type        = string
  description = "Vsphere datacenter name"
}

variable "vsphere_datastore" {
  type        = string
  description = "Vsphere datastore name"
}

variable "vsphere_resource_pool" {
  type        = string
  description = "Vsphere resource pool name"
}

variable "vsphere_network" {
  type        = string
  description = "Vsphere network name"
}

variable "vsphere_virtual_machine_template" {
  type        = string
  description = "Name of the virtual machine template to use for new VM creation"
}

variable "prefix" {
  type        = string
  description = "Prefix to use for various resources"
}

variable "ssh_private_key_path" {
  type        = string
  description = "SSH private key path"
}

variable "docker_version" {
  type        = string
  description = "Docker version"
  default     = "20.10"
}

variable "vm_username" {
  type        = string
  description = "Username used to connect to the VM"
}

variable "vm_cpus" {
  type        = number
  description = "CPU sizing for the VM"
  default     = 2
}

variable "vm_memory" {
  type        = number
  description = "Memory sizing for the VM"
  default     = 4096
}

variable "vm_disk" {
  type        = number
  description = "Disk sizing for the VM"
  default     = 80
}

variable "instance_count" {
  type        = number
  description = "Number of instances to create"
  default     = 3
}

variable "authorized_keys" {
  description = "Authorized keys to be added to the newly created VM"
}
