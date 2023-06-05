variable "vsphere_server" {
  description = "Add the vSphere hostname."
}

variable "vsphere_server_allow_unverified_ssl" {
  description = "Allow use of unverified SSL certificates (Ex: Self signed)"
}
variable "vsphere_user" {
  description = "Add your vSphere username."
}

variable "vsphere_password" {
  description = "Add your vSphere password for the above mentioned username."
}

variable "instance_count" {
  type        = number
  description = "Number of instances to create"
  default     = 3
}

variable "ssh_private_key_path" {
  description = "Add your SSH private key path here."
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

variable "vsphere_virtual_machine" {
  description = "Virtual Machine template name"
}

variable "vsphere_network" {
}