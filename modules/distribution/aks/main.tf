locals {
  kc_path        = var.kube_config_path != null ? var.kube_config_path : path.cwd
  kc_file        = var.kube_config_filename != null ? "${local.kc_path}/${var.kube_config_filename}" : "${local.kc_path}/${var.prefix}_kube_config.yml"
  kc_file_backup = "${local.kc_file}.backup"
}

resource "azurerm_resource_group" "rg" {
  location = var.azure_region
  name     = "${var.prefix}-rg"

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = var.prefix
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.prefix

  default_node_pool {
    name       = var.default_node_pool_name
    node_count = var.node_count
    vm_size    = var.vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "local_file" "kube_config_yaml" {
  filename        = local.kc_file
  content         = azurerm_kubernetes_cluster.this.kube_config_raw
  file_permission = "0600"
}

resource "local_file" "kube_config_yaml_backup" {
  filename        = local.kc_file_backup
  content         = azurerm_kubernetes_cluster.this.kube_config_raw
  file_permission = "0600"

  lifecycle {
    ignore_changes = [content]
  }
}
