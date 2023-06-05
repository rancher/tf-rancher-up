# TODO: Add description for the variables
# TODO: Remove any unused variables
variable "vsphere_server" {
  description = "Add the vSphere hostname."
}

variable "vsphere_server_allow_unverified_ssl" {
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

variable "vsphere_datacenter" {
  description = "vSphere Datacenter details."
}

variable "vsphere_datastore" {
  description = "Datastore used for storing VM data."
}

variable "vsphere_resource_pool" {
  description = "Available resourcepool on the host."
}

variable "vsphere_network" {
}

variable "vsphere_virtual_machine" {
  description = "Virtual Machine template name"
}

variable "prefix" {
  description = "Prefix to use for various resources"
}

variable "ssh_private_key_path" {
  description = "Add your Private Key"
}

variable "docker_version" {
  default = "20.10"
}

variable "vm_username" {
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
  type        = number
  description = "Number of instances to create"
  default     = 3
}

variable "authorized_keys" {
  description = "Add in your SSH public key. This will be added to the VMs by cloud-init in the authorized_keys file under ~/.ssh"
}
