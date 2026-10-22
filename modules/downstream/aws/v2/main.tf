locals {
  ami = var.ami != null ? var.ami : (var.os_type == "ubuntu" ? data.aws_ssm_parameter.ubuntu[0].insecure_value : data.aws_ssm_parameter.sles[0].insecure_value)

  use_custom_machine_pools = var.machine_pools != null

  # Accept either an availability zone suffix ("a") or a full AZ name ("us-east-1a").
  default_zone = try(regex("([a-z])$", var.zone)[0], var.zone)

  legacy_machine_pools = [
    {
      name                = var.cp_node_pool_name
      config_key          = "cp"
      generate_name       = "${var.cluster_name}-cp"
      roles               = ["etcd", "controlplane"]
      count               = var.cp_count
      drain_before_delete = true
      zone                = var.zone
      subnet_id           = var.subnet_id
      instance_type       = var.instance_type
      volume_size         = var.volume_size
      volume_type         = var.volume_type
      spot_instances      = var.cp_spot_instances
    },
    {
      name                = var.worker_node_pool_name
      config_key          = "w"
      generate_name       = "${var.cluster_name}-w"
      roles               = ["worker"]
      count               = var.worker_count
      drain_before_delete = true
      zone                = var.zone
      subnet_id           = var.subnet_id
      instance_type       = var.instance_type
      volume_size         = var.volume_size
      volume_type         = var.volume_type
      spot_instances      = var.worker_spot_instances
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
      zone                = pool.zone
      subnet_id           = pool.subnet_id
      instance_type       = coalesce(pool.instance_type, var.instance_type)
      volume_size         = coalesce(pool.volume_size, var.volume_size)
      volume_type         = coalesce(pool.volume_type, var.volume_type)
      spot_instances      = pool.spot_instances
    }
  ]

  resolved_pool_zones = {
    for pool in local.custom_machine_pools : pool.name => (
      pool.zone != null ? try(regex("([a-z])$", pool.zone)[0], pool.zone) : try(
        local.zone_suffix_by_subnet[coalesce(pool.subnet_id, var.subnet_id)],
        local.default_zone
      )
    )
  }

  resolved_custom_machine_pools = [
    for pool in local.custom_machine_pools : merge(pool, {
      zone = local.resolved_pool_zones[pool.name]
      subnet_id = pool.subnet_id != null ? pool.subnet_id : (
        var.subnet_id != null ? var.subnet_id : try(local.subnet_ids_by_zone[local.resolved_pool_zones[pool.name]][0], null)
      )
    })
  ]

  machine_pools   = local.use_custom_machine_pools ? local.resolved_custom_machine_pools : local.legacy_machine_pools
  machine_configs = { for pool in local.machine_pools : pool.config_key => pool }
}

resource "rancher2_cloud_credential" "aws_credential" {
  count       = var.cloud_credential_id != null ? 0 : 1
  name        = var.cluster_name
  description = "AWS Credential for Terraform"
  amazonec2_credential_config {
    access_key     = var.aws_access_key
    secret_key     = var.aws_secret_key
    default_region = var.aws_region
  }
}

resource "rancher2_machine_config_v2" "machine_config" {
  for_each = local.machine_configs

  generate_name = each.value.generate_name
  amazonec2_config {
    ami                   = local.ami
    region                = var.aws_region
    security_group        = [var.security_group_name]
    subnet_id             = each.value.subnet_id
    vpc_id                = local.use_custom_machine_pools ? local.effective_vpc_id : var.vpc_id
    zone                  = each.value.zone
    root_size             = each.value.volume_size
    instance_type         = each.value.instance_type
    volume_type           = each.value.volume_type
    request_spot_instance = each.value.spot_instances
    http_protocol_ipv6    = "disabled"
    ssh_user              = var.ssh_user
  }
}

moved {
  from = rancher2_machine_config_v2.cp_machine_config
  to   = rancher2_machine_config_v2.machine_config["cp"]
}

moved {
  from = rancher2_machine_config_v2.worker_machine_config
  to   = rancher2_machine_config_v2.machine_config["w"]
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
        cloud_credential_secret_name = var.cloud_credential_id != null ? var.cloud_credential_id : rancher2_cloud_credential.aws_credential[0].id
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

  lifecycle {
    precondition {
      condition = !local.use_custom_machine_pools || alltrue([
        for subnet in data.aws_subnet.provided : subnet.vpc_id == local.effective_vpc_id
      ])
      error_message = "All subnet IDs used by machine_pools must belong to the effective VPC (vpc_id, the subnets' VPC, or the AWS default VPC)."
    }
    precondition {
      condition     = !local.use_custom_machine_pools || local.effective_vpc_id != null
      error_message = "Could not determine a VPC for machine_pools. Set vpc_id, provide subnet IDs, or ensure the AWS account has a default VPC."
    }
    precondition {
      condition     = !local.use_custom_machine_pools || alltrue([for pool in local.resolved_custom_machine_pools : pool.zone != null])
      error_message = "Could not determine an availability zone for every machine pool. Set zone or subnet_id per pool."
    }
    precondition {
      condition     = !local.use_custom_machine_pools || alltrue([for pool in local.resolved_custom_machine_pools : pool.subnet_id != null])
      error_message = "Could not determine a subnet for every machine pool. Set subnet_id per pool, set the global subnet_id, or ensure the VPC has subnets in the requested zones."
    }
    precondition {
      condition     = !local.use_custom_machine_pools || alltrue([for pool in local.resolved_custom_machine_pools : try(local.zone_suffix_by_subnet[pool.subnet_id] == pool.zone, true)])
      error_message = "The subnet_id and zone for a machine pool must refer to the same availability zone."
    }
  }
}

resource "local_sensitive_file" "kubeconfig" {
  content         = rancher2_cluster_v2.cluster.kube_config
  filename        = "${path.cwd}/${var.cluster_name}_kube_config.yml"
  file_permission = "0600"
  depends_on      = [rancher2_cluster_v2.cluster]
}
