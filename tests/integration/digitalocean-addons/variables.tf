variable "prefix" {
  type        = string
  description = "Prefix applied to all resource names"
  default     = "addon-test"
}

variable "region" {
  type        = string
  description = "DigitalOcean region"
  default     = "sfo3"
}

variable "droplet_size" {
  type        = string
  description = "Droplet machine size"
  default     = "s-2vcpu-4gb"
}

variable "ssh_username" {
  type        = string
  description = "SSH username for the droplet"
  default     = "root"
}

variable "kube_config_path" {
  type        = string
  description = "Directory to write the kubeconfig file"
  default     = null
}

variable "kube_config_filename" {
  type        = string
  description = "Kubeconfig filename"
  default     = null
}

variable "k3s_version" {
  type        = string
  description = "K3S version to install"
  default     = null
}

variable "k3s_channel" {
  type        = string
  description = "K3S release channel"
  default     = null
}

variable "longhorn_default_replica_count" {
  type        = number
  description = "Number of Longhorn volume replicas"
  default     = 1
}

variable "longhorn_version" {
  type        = string
  description = "Longhorn Helm chart version"
  default     = "1.11.1"
}
