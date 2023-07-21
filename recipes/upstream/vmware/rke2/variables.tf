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

variable "vm_username" {
}

variable "authorized_keys" {
  description = "Add in your SSH public key. This will be added to the VMs by cloud-init in the authorized_keys file under ~/.ssh"
}

variable "prefix" {
  description = "Prefix to use for various resources"
}


variable "rke2_version" {
  type        = string
  description = "Kubernetes version to use for the RKE2 cluster"
  default     = null
}

variable "rke2_token" {
  description = "Token to use when configuring RKE2 nodes"
  default     = null
}

variable "rke2_config" {
  description = "Additional RKE2 configuration to add to the config.yaml file"
  default     = null
}


variable "rancher_password" {
  description = "Password to use for bootstrapping Rancher (min 12 characters)"
  default     = "initial-admin-password"
  type        = string
}

variable "rancher_version" {
  description = "Rancher version to install"
  default     = null
  type        = string
}

variable "kube_config_path" {
  description = "The path to write the kubeconfig for the RKE cluster"
  type        = string
  default     = null
}

variable "dependency" {
  description = "An optional variable to add a dependency from another resource (not used)"
  default     = null
}

# Setting it to true as we don't need docker to install. This setup is temporary as we will remove the docker install part from infra part and inject it as userdata in the recipe directly.
variable "is_rke2_or_k3s_cluster" {
  description = "Set it to true only if you intended to use RKE2 and K3S which skips the docker installation."
  default     = true
  type        = bool
}

# Setting it to false for Vsphere infra recipes.
variable "auto_resolve_public_ip_address" {
  description = "Set it to true if you are using AWS or any other cloud provider which has both Public and Private IP addresses."
  default     = false
  type        = bool
}