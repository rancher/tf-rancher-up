resource "rke_cluster" "this" {
  cluster_name = var.cluster_name

  dynamic "nodes" {
    for_each = var.rancher_nodes == null ? [1] : []
    content {
      address          = var.node_public_ip
      internal_address = var.node_internal_ip
      user             = var.node_username
      role             = ["controlplane", "etcd", "worker"]
      ssh_key          = file(pathexpand(var.ssh_private_key_path))
    }
  }

  dynamic "nodes" {
    for_each = var.rancher_nodes != null ? var.rancher_nodes : []
    content {
      address          = nodes.value.public_ip
      internal_address = nodes.value.private_ip
      role             = nodes.value.roles
      user             = var.node_username
      ssh_key          = file(pathexpand(var.ssh_private_key_path))
    }
  }

  kubernetes_version = var.kubernetes_version
  ssh_agent_auth     = var.ssh_agent_auth
#  cluster_yaml       = file(pathexpand(var.cluster_yaml))

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
  depends_on = [rke_cluster.this]
  filename = format("%s/%s", path.root, var.rke_kubeconfig_filename)
  content  = rke_cluster.this.kube_config_yaml
  file_permission = "0600"
}