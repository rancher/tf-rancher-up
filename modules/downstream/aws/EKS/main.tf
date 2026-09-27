data "aws_eks_cluster_versions" "default" {
  count        = var.kubernetes_version == null ? 1 : 0
  default_only = true
}

resource "null_resource" "kubernetes_version" {
  count = var.kubernetes_version == null ? 1 : 0

  triggers = {
    version = data.aws_eks_cluster_versions.default[0].cluster_versions[0].cluster_version
  }

  lifecycle {
    ignore_changes = [triggers["version"]]
  }
}

locals {
  kubernetes_version = var.kubernetes_version != null ? var.kubernetes_version : null_resource.kubernetes_version[0].triggers["version"]
}

resource "rancher2_cloud_credential" "aws_credential" {
  count       = var.cloud_credential_id != null ? 0 : 1
  name        = var.cluster_name
  description = "AWS Credential for Terraform"
  amazonec2_credential_config {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
  }
}

resource "rancher2_cluster" "ranchereks" {
  name        = var.cluster_name
  description = var.cluster_description

  eks_config_v2 {
    cloud_credential_id = var.cloud_credential_id != null ? var.cloud_credential_id : rancher2_cloud_credential.aws_credential[0].id
    region              = var.aws_region
    kubernetes_version  = local.kubernetes_version
    logging_types       = var.logging_types

    dynamic "node_groups" {
      for_each = var.node_groups
      content {
        name          = node_groups.value.name
        instance_type = node_groups.value.instance_type
        desired_size  = node_groups.value.desired_size
        max_size      = node_groups.value.max_size
        min_size      = node_groups.value.min_size
      }
    }
    private_access = var.private_access
    public_access  = var.public_access
  }
}
