module "downstream_rke2" {
  source = "../../../../modules/downstream/aws/rke2/"

  aws_access_key      = var.aws_access_key
  aws_secret_key      = var.aws_secret_key
  cloud_credential_id = var.cloud_credential_id
  aws_region          = var.aws_region
  vpc_id              = var.vpc_id
  zone                = var.zone
  subnet_id           = var.subnet_id
  security_group_name = var.security_group_name
  ssh_user            = var.ssh_user
  ami                 = var.ami
  instance_type       = var.instance_type
  volume_size         = var.volume_size
  spot_instances      = var.spot_instances

  cluster_name          = var.cluster_name
  kubernetes_version    = var.kubernetes_version
  worker_node_pool_name = var.worker_node_pool_name
  cp_node_pool_name     = var.cp_node_pool_name
  cp_count              = var.cp_count
  worker_count          = var.worker_count
  cni_provider          = var.cni_provider
}