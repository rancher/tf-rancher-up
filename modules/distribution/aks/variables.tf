variable "azure_subscription_id" {
  type        = string
  description = "Azure subscription id"
  default     = null
}

variable "azure_subscription_tenant_id" {
  type        = string
  description = "Azure subscription tenant id"
  default     = null
}

variable "azure_service_principal_appid" {
  type        = string
  description = "Azure service principal app id"
  default     = null
}

variable "azure_service_principal_password" {
  type        = string
  description = "Azure service principal password"
  default     = null
  sensitive   = true
}

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = "rancher-terraform"
}

variable "azure_region" {
  type        = string
  description = "Azure region used for all resources"
  default     = "westus3"
  validation {
    condition = contains([
      "australiacentral",
      "australiacentral2",
      "australiaeast",
      "australiasoutheast",
      "brazilsouth",
      "brazilsoutheast",
      "canadacentral",
      "canadaeast",
      "centralindia",
      "centralus",
      "eastasia",
      "eastus",
      "eastus2",
      "francecentral",
      "francesouth",
      "germanynorth",
      "germanywestcentral",
      "japaneast",
      "japanwest",
      "koreacentral",
      "koreasouth",
      "northcentralus",
      "northeurope",
      "norwayeast",
      "norwaywest",
      "polandcentral",
      "qatarcentral",
      "southafricanorth",
      "southafricawest",
      "southcentralus",
      "southindia",
      "southeastasia",
      "swedencentral",
      "switzerlandnorth",
      "switzerlandwest",
      "uaecentral",
      "uaenorth",
      "uksouth",
      "ukwest",
      "usgovarizona",
      "usgovtexas",
      "usgovvirginia",
      "westcentralus",
      "westeurope",
      "westindia",
      "westus",
      "westus2",
      "westus3",
    ], var.azure_region)
    error_message = "invalid region specified"
  }
}

variable "node_count" {
  type        = number
  description = "Number of nodes to create in the default node pool"
  default     = 3
  nullable    = false
}

variable "vm_size" {
  type        = string
  description = "VM Size for the default node pool"
  default     = "Standard_DS2_v2"
  nullable    = false
  validation {
    condition = contains([
      "Basic_A4",
      "Standard_A0",
      "Standard_A1",
      "Standard_A1_v2",
      "Standard_A2",
      "Standard_A2_v2",
      "Standard_A3",
      "Standard_A4",
      "Standard_A4_v2",
      "Standard_A5",
      "Standard_A6",
      "Standard_A7",
      "Standard_A8",
      "Standard_A9",
      "Standard_A10",
      "Standard_B1s",
      "Standard_B1ms",
      "Standard_B2s",
      "Standard_B2ms",
      "Standard_B4s",
      "Standard_B8s",
      "Standard_B16s",
      "Standard_B32s",
      "Standard_B64s",
      "Standard_DS1",
      "Standard_DS1_v2",
      "Standard_DS2",
      "Standard_DS2_v2",
      "Standard_DS3",
      "Standard_DS3_v2",
      "Standard_DS4",
      "Standard_DS4_v2",
      "Standard_DS5",
      "Standard_DS5_v2",
      "Standard_DS11",
      "Standard_DS11_v2",
      "Standard_DS12",
      "Standard_DS12_v2",
      "Standard_DS13",
      "Standard_DS13_v2",
      "Standard_DS14",
      "Standard_DS14_v2",
      "Standard_DS15",
      "Standard_DS15_v2",
      "Standard_D1",
      "Standard_D1_v2",
      "Standard_D2",
      "Standard_D2_v2",
      "Standard_D3",
      "Standard_D3_v2",
      "Standard_D4",
      "Standard_D4_v2",
      "Standard_D5",
      "Standard_D5_v2",
      "Standard_D11",
      "Standard_D11_v2",
      "Standard_D12",
      "Standard_D12_v2",
      "Standard_D13",
      "Standard_D13_v2",
      "Standard_D14",
      "Standard_D14_v2",
      "Standard_D15",
      "Standard_D15_v2",
      "Standard_E1s",
      "Standard_E1ms",
      "Standard_E2s",
      "Standard_E2ms",
      "Standard_E4s",
      "Standard_E8s",
      "Standard_E16s",
      "Standard_E32s",
      "Standard_E64s",
      "Standard_F1s",
      "Standard_F1ms",
      "Standard_F2s",
      "Standard_F2ms",
      "Standard_F4s",
      "Standard_F8s",
      "Standard_F16s",
      "Standard_F32s",
      "Standard_F64s",
      "Standard_G1s",
      "Standard_G1ms",
      "Standard_G2s",
      "Standard_G2ms",
      "Standard_G4s",
      "Standard_G8s",
      "Standard_G16s",
      "Standard_G32s",
      "Standard_G64s",
      "Standard_H1s",
      "Standard_H1ms",
      "Standard_H2s",
      "Standard_H2ms",
      "Standard_H4s",
      "Standard_H8s",
      "Standard_H16s",
      "Standard_H32s",
      "Standard_H64s",
      "Standard_NC6s_v2",
      "Standard_NC12s_v2",
      "Standard_NC24s_v2",
      "Standard_NC24rs_v2",
      "Standard_ND4s_v2",
      "Standard_ND6s_v2",
      "Standard_ND12s_v2",
      "Standard_NV6s",
      "Standard_NV12s",
    ], var.vm_size)
    error_message = "invalid vm size specified"
  }
}

variable "kube_config_path" {
  description = "The path to write the kubeconfig for the AKS cluster"
  type        = string
  default     = null
}

variable "kube_config_filename" {
  description = "Filename to write the kube config"
  type        = string
  default     = null
}

variable "default_node_pool_name" {
  description = "Customize the default node pool name"
  type        = string
  default     = "defaultnp"
}
