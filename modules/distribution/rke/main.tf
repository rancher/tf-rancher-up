locals {
  kube_config_file = var.kube_config_path != null ? var.kube_config_path : "${path.cwd}/${var.prefix}_kube_config.yml"
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
    for_each = var.rancher_nodes != null ? var.rancher_nodes : []
    content {
      address          = nodes.value.public_ip
      internal_address = nodes.value.private_ip
      role             = nodes.value.roles
      user             = var.node_username
      ssh_key          = var.dependency != null ? file(pathexpand(var.ssh_private_key_path)) : null
    }
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
}

resource "local_file" "kube_config_yaml" {
  filename        = local.kube_config_file
  content         = rke_cluster.this.kube_config_yaml
  file_permission = "0600"
}

resource "local_file" "kube_config_yaml_backup" {
  filename        = "${local.kube_config_file}.bkp"
  content         = rke_cluster.this.kube_config_yaml
  file_permission = "0600"

  lifecycle {
    ignore_changes = [content]
  }
}