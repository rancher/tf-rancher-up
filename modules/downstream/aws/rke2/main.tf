resource "null_resource" "wait_for_cluster_creation" {
  provisioner "local-exec" {
    command = "${path.module}/check_cluster_status.sh ${var.rancher_api_key} ${var.rancher_secret_key} ${var.rancher_url} ${rancher2_cluster_v2.rke2_ds_tf.cluster_v1_id}"
  }

  depends_on = [
    rancher2_cluster_v2.rke2_ds_tf
  ]
}

resource "rancher2_cloud_credential" "aws_credential" {
  name        = var.creds_name
  description = "AWS Credential for Terraform"
  amazonec2_credential_config {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
  }
}

resource "rancher2_machine_config_v2" "rke2_machine_config" {
  generate_name = "exampleconfig"
  amazonec2_config {
    ami            = var.ami
    region         = var.aws_region
    security_group = [var.aws_security_group_name]
    subnet_id      = var.subnet_id
    vpc_id         = var.vpc_id
    zone           = var.vpc_zone
    root_size      = var.instance_disk_size
  }
}


resource "rancher2_cluster_v2" "rke2_ds_tf" {
  name               = var.cluster_name
  kubernetes_version = var.rke2_kubernetes_version
  rke_config {
    machine_pools {
      name                         = var.master_pool_name
      cloud_credential_secret_name = rancher2_cloud_credential.aws_credential.id
      control_plane_role           = true
      etcd_role                    = true
      worker_role                  = false
      quantity                     = var.master_quantity
      drain_before_delete          = true
      machine_config {
        kind = rancher2_machine_config_v2.rke2_machine_config.kind
        name = rancher2_machine_config_v2.rke2_machine_config.name
      }
    }
    machine_pools {
      name                         = var.worker_pool_name
      cloud_credential_secret_name = rancher2_cloud_credential.aws_credential.id
      control_plane_role           = false
      etcd_role                    = false
      worker_role                  = true
      quantity                     = var.worker_quantity
      drain_before_delete          = true
      machine_config {
        kind = rancher2_machine_config_v2.rke2_machine_config.kind
        name = rancher2_machine_config_v2.rke2_machine_config.name
      }
    }
  }
}
