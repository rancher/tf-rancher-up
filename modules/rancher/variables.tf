variable "kubeconfig_file" {
  description = "The kubeconfig to use to interact with the cluster"
  default     = "~/.kube/config"
  type        = string
}

variable "airgap" {
  description = "Enable airgap options for the Rancher environment, requires default_registry to be set"
  default     = false
  type        = bool
}

variable "bootstrap_rancher" {
  description = "Bootstrap the Rancher installation"
  default     = true
  type        = bool
}

variable "cert_manager_namespace" {
  description = "Namespace to install cert-manager"
  default     = "cert-manager"
  type        = string
}

variable "cert_manager_version" {
  description = "Version of cert-manager to install"
  default     = "v1.11.0"
  type        = string
}

variable "cert_manager_enable" {
  description = "Install cert-manager even if not needed for Rancher, useful if migrating to certificates"
  default     = false
  type        = string
}

variable "default_registry" {
  description = "Default container image registry to pull images in the format of registry.domain.com:port (systemDefaultRegistry helm value)"
  default     = null
  type        = string
}

variable "helm_repository" {
  description = "Helm repository for Rancher and cert-manager charts"
  default     = null
  type        = string
}

variable "rancher_additional_helm_values" {
  description = "Helm options to provide to the Rancher helm chart"
  default     = []
  type        = list(string)
}

variable "rancher_antiaffinity" {
  description = "Value for antiAffinity when installing the Rancher helm chart (required/preferred)"
  default     = "required"
  type        = string
}

variable "rancher_bootstrap_password" {
  description = "Password to use for bootstrapping Rancher (min 12 characters)"
  default     = "initial-admin-password"
  type        = string

  validation {
    condition     = length(var.rancher_bootstrap_password) >= 12
    error_message = "The password provided for Rancher (rancher_bootstrap_password) must be at least 12 characters"
  }
}

variable "rancher_password" {
  description = "Password to use for Rancher (min 12 characters)"
  default     = null
  type        = string

  validation {
    condition     = length(var.rancher_password) >= 12
    error_message = "The password provided for Rancher (rancher_password) must be at least 12 characters"
  }
}

variable "rancher_hostname" {
  description = "Value for hostname when installing the Rancher helm chart"
  type        = string
}

variable "rancher_namespace" {
  description = "The Rancher release will be deployed to this namespace"
  type        = string
  default     = "cattle-system"
}

variable "rancher_replicas" {
  description = "Value for replicas when installing the Rancher helm chart"
  default     = 3
  type        = number
}

variable "rancher_version" {
  description = "Rancher version to install"
  default     = null
  type        = string
}

variable "helm_username" {
  description = "Private helm repository username"
  default     = null
  type        = string
}

variable "helm_password" {
  description = "Private helm repository password"
  default     = null
  type        = string
}

variable "registry_username" {
  description = "Private container image registry username"
  default     = null
  type        = string
}

variable "registry_password" {
  description = "Private container image registry password"
  default     = null
  type        = string
}

variable "cacerts_path" {
  default     = null
  description = "Private CA certificate to use for Rancher UI/API connectivity"
  type        = string
}

variable "tls_crt_path" {
  description = "TLS certificate to use for Rancher UI/API connectivity"
  default     = null
  type        = string
}

variable "tls_key_path" {
  description = "TLS key to use for Rancher UI/API connectivity"
  default     = null
  type        = string
}

variable "tls_source" {
  description = "Value for ingress.tls.source when installing the Rancher helm chart"
  default     = "rancher"
  type        = string
}

variable "dependency" {
  description = "An optional variable to add a dependency from another resource (not used)"
  default     = null
}

variable "wait" {
  description = "An optional wait before installing the Rancher helm chart (seconds)"
  default     = null
}

variable "helm_timeout" {
  description = "Specify the timeout value in seconds for helm operation(s)"
  default     = 600
  type        = number
}
