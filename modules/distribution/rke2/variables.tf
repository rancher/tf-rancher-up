variable "public_key_path" {
  description = "path of public key for nodes"
  default     = null
}

variable "node_public_ip" {
  type        = string
  description = "Public IP address for single node RKE cluster"
  default     = null
}

variable "node_internal_ip" {
  type        = string
  description = "Internal IP address for single node RKE cluster"
  default     = null
}
variable "rancher_kubernetes_version" {
  type        = string
  description = "Kubernetes version to use for the RKE cluster"
  default     = "v1.23.16+rke2r1"
}


variable "cp_vm_count" {
  default     = 3
  description = "Number of VMs to spin up for RKEs"
}


variable "rancher_nodes" {
  type = list(object({
    public_ip  = string
    private_ip = string
  }))
  default     = null
  description = "List of compute nodes for Rancher cluster"
}


variable "node_username" {
  type        = string
  default     = "ubuntu"
  description = "Username used for SSH access to the Rancher server cluster node"
}


variable "ssh_private_key_path" {
  type        = string
  description = "Private key used for SSH access to the Rancher server cluster node(s)"
  default     = null
}

variable "ssh_key_pair_path" {
  type        = string
  description = "Private key used for SSH access to the Rancher server cluster node(s)"
  default     = null
}

variable "vm_name_prefix" {
  description = "Prefix for the VM name in vSphere"
  default     = "rancher-ha"
}

variable "rke2_token" {
  default     = "mytoken"
  description = "Desired RKE2 token"
}


variable "cluster_name" {
  type        = string
  description = "Name for the RKE cluster"
  default     = "rke2-tf"
}


variable "rke2_kubeconfig_filename" {
  type        = string
  description = "Kubeconfig output filename to use"
  default     = "kube_config_cluster.yml"
}

variable "dependency" {
  description = "An optional variable to add a dependency from another resource (not used)"
}




