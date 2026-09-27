locals {
  ami = var.ami != null ? var.ami : (var.os_type == "ubuntu" ? data.aws_ssm_parameter.ubuntu[0].insecure_value : data.aws_ssm_parameter.sles[0].insecure_value)
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

resource "rancher2_machine_config_v2" "cp_machine_config" {
  generate_name = "${var.cluster_name}-cp"
  amazonec2_config {
    ami                   = local.ami
    region                = var.aws_region
    security_group        = [var.security_group_name]
    subnet_id             = var.subnet_id
    vpc_id                = var.vpc_id
    zone                  = var.zone
    root_size             = var.volume_size
    instance_type         = var.instance_type
    volume_type           = var.volume_type
    request_spot_instance = var.cp_spot_instances
    http_protocol_ipv6    = "disabled"
    ssh_user              = var.ssh_user
  }
}

resource "rancher2_machine_config_v2" "worker_machine_config" {
  generate_name = "${var.cluster_name}-w"
  amazonec2_config {
    ami                   = local.ami
    region                = var.aws_region
    security_group        = [var.security_group_name]
    subnet_id             = var.subnet_id
    vpc_id                = var.vpc_id
    zone                  = var.zone
    root_size             = var.volume_size
    instance_type         = var.instance_type
    volume_type           = var.volume_type
    request_spot_instance = var.worker_spot_instances
    http_protocol_ipv6    = "disabled"
    ssh_user              = var.ssh_user
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

    machine_pools {
      name                         = var.cp_node_pool_name
      cloud_credential_secret_name = var.cloud_credential_id != null ? var.cloud_credential_id : rancher2_cloud_credential.aws_credential[0].id
      control_plane_role           = true
      etcd_role                    = true
      worker_role                  = false
      quantity                     = var.cp_count
      drain_before_delete          = true
      machine_config {
        kind = rancher2_machine_config_v2.cp_machine_config.kind
        name = rancher2_machine_config_v2.cp_machine_config.name
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
        kind = rancher2_machine_config_v2.worker_machine_config.kind
        name = rancher2_machine_config_v2.worker_machine_config.name
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
