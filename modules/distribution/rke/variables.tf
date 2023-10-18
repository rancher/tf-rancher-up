variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
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

variable "rancher_nodes" {
  type = list(object({
    public_ip  = string
    private_ip = string
    roles      = list(string)
  }))
  default     = null
  description = "List of compute nodes for Rancher cluster"
}

variable "node_username" {
  type        = string
  description = "Username used for SSH access to the Rancher server cluster node"
  default     = "ubuntu"
}

variable "ssh_private_key_path" {
  type        = string
  description = "Private key used for SSH access to the Rancher server cluster node(s)"
  default     = null
}

variable "ssh_agent_auth" {
  type        = bool
  description = "Enable SSH agent authentication"
  default     = false
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version to use for the RKE cluster"
  default     = null
}

variable "private_registry_url" {
  type        = string
  description = "Specify the private registry where kubernetes images are hosted. Ex: artifactory.company.com/docker"
  default     = null
}

variable "private_registry_username" {
  type        = string
  description = "Specify private registry's username"
  default     = null
}

variable "private_registry_password" {
  type        = string
  description = "Specify private registry's password"
  default     = null
}

variable "cluster_name" {
  type        = string
  description = "Name for the RKE cluster"
  default     = "rke-demo"
}

variable "cluster_yaml" {
  type        = string
  description = "cluster.yaml configuration file to apply to the cluster"
  default     = null
}

variable "kube_config_path" {
  description = "The path to write the kubeconfig for the RKE cluster"
  type        = string
  default     = null
}

variable "kube_config_filename" {
  description = "Filename to write the kube config"
  type        = string
  default     = null
}

variable "dependency" {
  description = "An optional variable to add a dependency from another resource (not used)"
  default     = null
}

variable "ingress_provider" {
  description = "Ingress controller provider. nginx (default), and none are supported (string)"
  default     = "nginx"
}
