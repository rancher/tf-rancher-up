locals {
  kc_path        = var.kube_config_path != null ? var.kube_config_path : path.cwd
  kc_file        = var.kube_config_filename != null ? "${local.kc_path}/${var.kube_config_filename}" : "${local.kc_path}/${var.prefix}_kube_config.yml"
  kc_file_backup = "${local.kc_file}.backup"
}

resource "rke_cluster" "this" {
  depends_on   = [var.dependency]
  cluster_name = var.cluster_name

  dynamic "nodes" {
    for_each = var.rancher_nodes == null ? [1] : []
    content {
      address          = var.node_public_ip
      internal_address = var.node_internal_ip
      user             = var.node_username
      role             = ["controlplane", "etcd", "worker"]
      ssh_key          = var.dependency != null ? file(pathexpand(var.ssh_private_key_path)) : null
    }
  }

  dynamic "nodes" {
    for_each = {
      for index, node in var.rancher_nodes :
      index => node
    }
    content {
      hostname_override = nodes.value.hostname_override != null ? nodes.value.hostname_override : null
      address           = nodes.value.public_ip != null && nodes.value.public_ip != "" ? nodes.value.public_ip : nodes.value.private_ip
      internal_address  = nodes.value.public_ip != null && nodes.value.public_ip != "" ? nodes.value.private_ip : null
      role              = nodes.value.roles
      user              = var.node_username
      ssh_key           = nodes.value.ssh_key != null ? nodes.value.ssh_key : null
      ssh_key_path      = nodes.value.ssh_key_path != null ? nodes.value.ssh_key_path : null
    }
  }

  bastion_host {
    address      = var.bastion_host != null ? var.bastion_host.address : ""
    user         = var.bastion_host != null ? var.bastion_host.user : ""
    ssh_key_path = var.bastion_host != null ? var.bastion_host.ssh_key_path : ""
    ssh_key      = var.bastion_host != null ? var.bastion_host.ssh_key : ""
  }

  kubernetes_version = var.kubernetes_version
  ssh_agent_auth     = var.ssh_agent_auth
  addon_job_timeout  = 120
  enable_cri_dockerd = true

  dynamic "private_registries" {
    for_each = var.private_registry_url != null ? [1] : []
    content {
      url        = var.private_registry_url
      user       = var.private_registry_username
      password   = var.private_registry_password
      is_default = true
    }
  }

  ingress {
    provider     = var.ingress_provider
    http_port    = var.ingress_http_port
    https_port   = var.ingress_https_port
    network_mode = var.ingress_network_mode
  }

  dynamic "cloud_provider" {
    for_each = var.cloud_provider != null ? [1] : []
    content {
      name = var.cloud_provider
    }
  }
}

resource "local_file" "kube_config_yaml" {
  count           = var.create_kubeconfig_file ? 1 : 0
  filename        = local.kc_file
  content         = rke_cluster.this.kube_config_yaml
  file_permission = "0600"
}

resource "local_file" "kube_config_yaml_backup" {
  count           = var.create_kubeconfig_file ? 1 : 0
  filename        = local.kc_file_backup
  content         = rke_cluster.this.kube_config_yaml
  file_permission = "0600"

  lifecycle {
    ignore_changes = [content]
  }
}
