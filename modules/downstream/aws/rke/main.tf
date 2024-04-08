resource "rancher2_cloud_credential" "aws_credential" {
  count       = var.cloud_credential_id != null ? 0 : 1
  name        = "${var.prefix}-${var.cluster_name}"
  description = "AWS Credential for Terraform"
  amazonec2_credential_config {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
  }
}

resource "rancher2_node_template" "node_template" {
  name                = "${var.prefix}-${var.cluster_name}"
  description         = "RKE Node Template"
  cloud_credential_id = var.cloud_credential_id != null ? var.cloud_credential_id : rancher2_cloud_credential.aws_credential[0].id
  amazonec2_config {
    instance_type         = var.instance_type
    root_size             = var.volume_size
    region                = var.aws_region
    vpc_id                = var.vpc_id
    zone                  = var.zone
    subnet_id             = var.subnet_id
    security_group        = [var.security_group_name]
    ssh_user              = var.ssh_user
    ami                   = var.ami
    request_spot_instance = var.spot_instances
  }
}

resource "rancher2_cluster" "cluster" {
  name               = var.cluster_name
  description        = "Managed by Terraform"
  kubernetes_version = var.kubernetes_version
  rke_config {
    enable_cri_dockerd = true
    network {
      plugin = var.cni_provider
    }
  }
}

resource "rancher2_node_pool" "worker_node_pool" {
  name             = "${var.prefix}-${var.worker_node_pool_name}"
  cluster_id       = rancher2_cluster.cluster.id
  hostname_prefix  = "${var.prefix}-${var.worker_node_pool_name}-"
  node_template_id = rancher2_node_template.node_template.id
  count            = var.worker_count
  worker           = true
}

resource "rancher2_node_pool" "master_node_pool" {
  name             = "${var.prefix}-${var.cp_node_pool_name}"
  hostname_prefix  = "${var.prefix}-${var.cp_node_pool_name}-"
  cluster_id       = rancher2_cluster.cluster.id
  node_template_id = rancher2_node_template.node_template.id
  count            = var.cp_count
  etcd             = true
  control_plane    = true
}

resource "rancher2_cluster_sync" "sync" {
  depends_on = [rancher2_cluster_v2.cluster]
  cluster_id = rancher2_cluster.cluster.id
}