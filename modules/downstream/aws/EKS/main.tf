resource "rancher2_cloud_credential" "eks_cred" {
  name        = var.cloud_credential_name
  description = var.cloud_credential_description

  amazonec2_credential_config {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
  }
}

resource "rancher2_cluster" "ranchereks" {
  name        = var.cluster_name
  description = var.cluster_description

  eks_config_v2 {
    cloud_credential_id = rancher2_cloud_credential.eks_cred.id
    region              = var.aws_region
    kubernetes_version  = var.kubernetes_version
    logging_types       = var.logging_types

    # Dynamic node groups
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