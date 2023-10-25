provider "azurerm" {
  features {}

  subscription_id = var.azure_subscription_id != null ? var.azure_subscription_id : null
  tenant_id       = var.azure_subscription_tenant_id != null ? var.azure_subscription_tenant_id : null
  client_id       = var.azure_service_principal_appid != null ? var.azure_service_principal_appid : null
  client_secret   = var.azure_service_principal_password != null ? var.azure_service_principal_password : null
}
