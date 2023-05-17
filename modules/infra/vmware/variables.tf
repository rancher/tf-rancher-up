# TODO: Add description for the variables
# TODO: Remove any unused variables
variable "vsphere_server" {
}

variable "vsphere_server_allow_unverified_ssl" {
  description = "Allow use of unverified SSL certificates (Ex: Self signed)"
  default = false
}
variable "vsphere_user" {
}

variable "vsphere_password" {
}

variable "vsphere_datacenter" {
}

variable "vsphere_datastore" {
}

variable "vsphere_resource_pool" {
}

variable "vsphere_network" {
}

variable "vsphere_virtual_machine" {
  description = "Virtual Machine template name"
}

variable "prefix" {
  description = "Prefix to use for various resources"
}

variable "authorized_keys" {
}

variable "ssh_private_key_path" {
  default = "~/.ssh/id_rsa"
}

variable "docker_version" {
  default = "20.10"
}

variable "vm_username" {
  default = "root"
}

variable "vm_cpus" {
  default = 2
}

variable "vm_memory" {
  default = 4096
}

variable "vm_disk" {
  default = 80
}

variable "instance_count" {
  type    = number
  description = "Number of instances to create"
  default = 3
}
