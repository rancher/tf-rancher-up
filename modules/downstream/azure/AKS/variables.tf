variable "rancher_url" {
  description = "The Rancher server URL"
  type        = string
}

variable "rancher_insecure" {
  description = "Skip TLS verification for Rancher API"
  type        = bool
  default     = true
}

variable "rancher_token" {
  description = "Rancher API token"
  default     = null
  type        = string
}


variable "cloud_credential_id" {
  description = "Rancher cloud credential to use, instead of AZURE client id/secret (ex: cattle-global-data:cc-xxx)"
  type        = string
  default     = null
}
variable "client_id" {
  description = "Azure client ID"
  type        = string
  default     = null
}

variable "client_secret" {
  description = "Azure client secret"
  type        = string
  default     = null
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  default     = null
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = null
}

variable "cluster_description" {
  description = "Description of the AKS cluster"
  type        = string
   default     = null
}

variable "resource_group" {
  description = "Azure resource group name"
  type        = string
}

variable "resource_location" {
  type        = string
  description = "Azure region used for all resources"
  default     = "eastus"

  validation {
    condition = contains([
      "eastus",
      "eastus2",
      "southcentralus",
      "westus2",
      "westus3",
      "australiaeast",
      "southeastasia",
      "northeurope",
      "swedencentral",
      "uksouth",
      "westeurope",
      "centralus",
      "southafricanorth",
      "centralindia",
      "eastasia",
      "japaneast",
      "koreacentral",
      "canadacentral",
      "francecentral",
      "germanywestcentral",
      "norwayeast",
      "switzerlandnorth",
      "uaenorth",
      "brazilsouth",
    ], var.resource_location)
    error_message = "Invalid Azure region specified!"
  }
}


variable "dns_prefix" {
  description = "DNS prefix for the cluster"
  type        = string
  default     = null
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.33.2"
}

variable "network_plugin" {
  description = "Network plugin to use"
  type        = string
  default     = "kubenet"
}

variable "node_pools" {
  description = "List of node pools configuration"
  type = list(object({
    availability_zones   = list(string)
    name                 = string
    count                = number
    orchestrator_version = string
    os_disk_size_gb      = number
    vm_size              = string
  }))
}