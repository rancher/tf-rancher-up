locals {
  use_custom_machine_pools = var.machine_pools != null

  legacy_machine_pools = [
    {
      name                = var.cp_node_pool_name
      config_key          = "cp"
      generate_name       = "${var.cluster_name}-cp"
      roles               = ["etcd", "controlplane"]
      count               = var.cp_count
      drain_before_delete = true
      region              = var.region
      size                = var.size
      image               = var.image
    },
    {
      name                = var.worker_node_pool_name
      config_key          = "w"
      generate_name       = "${var.cluster_name}-w"
      roles               = ["worker"]
      count               = var.worker_count
      drain_before_delete = true
      region              = var.region
      size                = var.size
      image               = var.image
    },
  ]

  custom_machine_pools = [
    for pool in coalesce(var.machine_pools, []) : {
      name                = pool.name
      config_key          = pool.name
      generate_name       = "${var.cluster_name}-${pool.name}"
      roles               = pool.roles
      count               = pool.count
      drain_before_delete = pool.drain_before_delete
      region              = coalesce(pool.region, var.region)
      size                = coalesce(pool.size, var.size)
      image               = coalesce(pool.image, var.image)
    }
  ]

  machine_pools   = local.use_custom_machine_pools ? local.custom_machine_pools : local.legacy_machine_pools
  machine_configs = { for pool in local.machine_pools : pool.config_key => pool }
}

resource "rancher2_cloud_credential" "do_credential" {
  count       = var.cloud_credential_id != null ? 0 : 1
  name        = var.cluster_name
  description = "DigitalOcean Credential for Terraform"
  digitalocean_credential_config {
    access_token = var.do_token
  }
}

resource "rancher2_machine_config_v2" "machine_config" {
  for_each = local.machine_configs

  generate_name = each.value.generate_name
  digitalocean_config {
    image               = each.value.image
    region              = each.value.region
    size                = each.value.size
    ssh_user            = var.ssh_user
    ssh_key_fingerprint = var.ssh_key_fingerprint
    ssh_key_contents    = var.ssh_key_contents
    ssh_port            = var.ssh_port
    private_networking  = var.private_networking
    ipv6                = var.ipv6
    monitoring          = var.monitoring
    backups             = var.backups
    tags                = var.tags
    userdata            = var.custom_user_data
  }
}

resource "rancher2_cluster_v2" "cluster" {
  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version

  rke_config {

    machine_global_config = <<-EOT
      cni: "${var.cni_provider}"
      ingress-controller: "${var.rke2_ingress}"
    EOT

    dynamic "machine_pools" {
      for_each = local.machine_pools
      content {
        name                         = machine_pools.value.name
        cloud_credential_secret_name = var.cloud_credential_id != null ? var.cloud_credential_id : rancher2_cloud_credential.do_credential[0].id
        control_plane_role           = contains(machine_pools.value.roles, "controlplane")
        etcd_role                    = contains(machine_pools.value.roles, "etcd")
        worker_role                  = contains(machine_pools.value.roles, "worker")
        quantity                     = machine_pools.value.count
        drain_before_delete          = machine_pools.value.drain_before_delete
        machine_config {
          kind = rancher2_machine_config_v2.machine_config[machine_pools.value.config_key].kind
          name = rancher2_machine_config_v2.machine_config[machine_pools.value.config_key].name
        }
      }
    }
  }
}

resource "local_sensitive_file" "kubeconfig" {
  content         = rancher2_cluster_v2.cluster.kube_config
  filename        = "${path.cwd}/${var.cluster_name}_kube_config.yml"
  file_permission = "0600"
  depends_on      = [rancher2_cluster_v2.cluster]
}