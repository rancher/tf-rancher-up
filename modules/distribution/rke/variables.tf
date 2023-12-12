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
    hostname_override = string
    public_ip         = string
    private_ip        = string
    roles             = list(string)
    ssh_key           = string
    ssh_key_path      = string
  }))
  default     = null
  description = "List of compute nodes for Rancher cluster"
}

variable "bastion_host" {
  type = object({
    address      = string
    user         = string
    ssh_key      = string
    ssh_key_path = string
  })
  default     = null
  description = "Bastion host configuration to access the RKE nodes"
}

variable "node_username" {
  type        = string
  description = "Username used for SSH access to the Rancher server cluster node"
  default     = "ubuntu"
}

variable "ssh_key" {
  type        = string
  description = "Private key used for SSH access to the Rancher server cluster node(s)"
  default     = null
}

variable "ssh_private_key_path" {
  type        = string
  description = "Path to private key used for SSH access to the Rancher server cluster node(s)"
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

variable "ingress_network_mode" {
  description = "Specify the network mode to use with Ingress"
  type        = string
  default     = "hostPort"
}

variable "ingress_http_port" {
  description = "Specify the http port number to use with Ingress"
  type        = number
  default     = 80
}

variable "ingress_https_port" {
  description = "Specify the https port number to use with Ingress"
  type        = number
  default     = 443
}

variable "cloud_provider" {
  description = "Specify the cloud provider name"
  type        = string
  default     = null
}

variable "create_kubeconfig_file" {
  description = "Boolean flag to generate a kubeconfig file (mostly used for dev only)"
  default     = true
}
