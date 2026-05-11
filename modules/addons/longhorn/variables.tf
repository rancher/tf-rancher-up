variable "kubeconfig_file" {
  description = "Path to the kubeconfig file to use for the installation"
  type        = string
}

variable "longhorn_namespace" {
  description = "Namespace to install Longhorn into"
  default     = "longhorn-system"
  type        = string
}

variable "longhorn_version" {
  description = "Version of the Longhorn helm chart to install"
  default     = "1.11.1"
  type        = string
}

variable "longhorn_helm_repository" {
  description = "Helm repository URL for Longhorn (null defaults to https://charts.longhorn.io)"
  default     = null
  type        = string
}

variable "longhorn_helm_repository_username" {
  description = "Username for the Longhorn helm repository"
  default     = null
  type        = string
}

variable "longhorn_helm_repository_password" {
  description = "Password for the Longhorn helm repository"
  default     = null
  type        = string
  sensitive   = true
}

variable "longhorn_helm_atomic" {
  description = "If set, installation process purges chart on fail; the wait flag will be set automatically if atomic is used"
  default     = false
  type        = bool
}

variable "longhorn_helm_upgrade_install" {
  description = "If set, will run helm upgrade --install"
  default     = true
  type        = bool
}

variable "longhorn_helm_timeout" {
  description = "Specify the timeout value in seconds for helm operation(s)"
  default     = 600
  type        = number
}

variable "longhorn_default_storage_class" {
  description = "Whether to set Longhorn as the default storage class for the cluster"
  default     = true
  type        = bool
}

variable "longhorn_default_replica_count" {
  description = "Default number of replicas for Longhorn volumes"
  default     = 3
  type        = number
}

variable "longhorn_additional_helm_values" {
  description = "Helm options to provide to the Longhorn helm chart in key:value format"
  default     = []
  type        = list(string)
}

variable "airgap" {
  description = "If set, configure Longhorn to pull images from system_default_registry instead of Docker Hub"
  default     = false
  type        = bool
}

variable "system_default_registry" {
  description = "Private container image registry to use when airgap is enabled"
  default     = null
  type        = string
}

variable "dependency" {
  description = "An optional variable to add a dependency from another resource (not used directly)"
  default     = null
}
