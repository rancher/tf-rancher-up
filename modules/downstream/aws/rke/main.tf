resource "null_resource" "wait_for_cluster_creation" {
  provisioner "local-exec" {
    command = "${path.module}/check_cluster_status.sh ${var.rancher_api_key} ${var.rancher_secret_key} ${var.rancher_url} ${rancher2_cluster.example_cluster.id}"
  }

  depends_on = [
    rancher2_cluster.example_cluster
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

resource "rancher2_node_template" "example_node_template" {
  name                = var.node_template_name
  description         = "RKE Node Template"
  cloud_credential_id = rancher2_cloud_credential.aws_credential.id
  amazonec2_config {
    instance_type  = var.aws_instance_type
    root_size      = var.aws_instance_size
    region         = var.aws_region
    vpc_id         = var.aws_vpc_id
    zone           = var.vpc_zone
    subnet_id      = var.subnet_id
    security_group = [var.aws_security_group_name]
    ssh_user       = var.ssh_user
    ami            = var.ami
  }
}

resource "rancher2_cluster" "example_cluster" {
  name        = var.cluster_name
  description = "Test RKE cluster"
  rke_config {
    network {
      plugin = "canal"
    }
  }
}

resource "rancher2_node_pool" "worker__node_pool" {
  name             = var.worker_node_pool_name
  cluster_id       = rancher2_cluster.example_cluster.id
  hostname_prefix  = var.worker_hostname_prefix
  node_template_id = rancher2_node_template.example_node_template.id
  quantity         = var.worker_quantity
  worker           = true
}


resource "rancher2_node_pool" "master__node_pool" {
  name             = var.master_node_pool_name
  hostname_prefix  = var.master_hostname_prefix
  cluster_id       = rancher2_cluster.example_cluster.id
  node_template_id = rancher2_node_template.example_node_template.id
  quantity         = var.master_quantity
  etcd             = true
  control_plane    = true
}
