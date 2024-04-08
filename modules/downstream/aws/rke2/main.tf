resource "rancher2_cloud_credential" "aws_credential" {
  count       = var.cloud_credential_id != null ? 0 : 1
  name        = "${var.prefix}-${var.cluster_name}"
  description = "AWS Credential for Terraform"
  amazonec2_credential_config {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
  }
}

resource "rancher2_machine_config_v2" "machine_config" {
  generate_name = "${var.prefix}-${var.cluster_name}"
  amazonec2_config {
    ami                   = var.ami
    region                = var.aws_region
    security_group        = [var.security_group_name]
    subnet_id             = var.subnet_id
    vpc_id                = var.vpc_id
    zone                  = var.zone
    root_size             = var.volume_size
    instance_type         = var.instance_type
    request_spot_instance = var.spot_instances
  }
}

resource "rancher2_cluster_v2" "cluster" {
  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version

  rke_config {

    machine_global_config = <<-EOF
      cni: "${var.cni_provider}"
    EOF

    machine_pools {
      name                         = var.cp_node_pool_name
      cloud_credential_secret_name = var.cloud_credential_id != null ? var.cloud_credential_id : rancher2_cloud_credential.aws_credential[0].id
      control_plane_role           = true
      etcd_role                    = true
      worker_role                  = false
      quantity                     = var.cp_count
      drain_before_delete          = true
      machine_config {
        kind = rancher2_machine_config_v2.machine_config.kind
        name = rancher2_machine_config_v2.machine_config.name
      }
    }
    machine_pools {
      name                         = var.worker_node_pool_name
      cloud_credential_secret_name = var.cloud_credential_id != null ? var.cloud_credential_id : rancher2_cloud_credential.aws_credential[0].id
      control_plane_role           = false
      etcd_role                    = false
      worker_role                  = true
      quantity                     = var.worker_count
      drain_before_delete          = true
      machine_config {
        kind = rancher2_machine_config_v2.machine_config.kind
        name = rancher2_machine_config_v2.machine_config.name
      }
    }
  }
}