terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.75.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = ">= 1.9.0"
    }
  }
}
