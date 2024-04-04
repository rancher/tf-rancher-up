module "downstream_rke" {
  source = "../../../../modules/downstream/aws/rke/"

  rancher_url        = var.rancher_url
  rancher_api_key    = var.rancher_api_key
  rancher_secret_key = var.rancher_secret_key

  aws_access_key          = var.aws_access_key
  aws_secret_key          = var.aws_secret_key
  creds_name              = var.creds_name
  aws_region              = var.aws_region
  aws_vpc_id              = var.aws_vpc_id
  vpc_zone                = var.vpc_zone
  subnet_id               = var.subnet_id
  aws_security_group_name = var.aws_security_group_name
  ssh_user                = var.ssh_user
  ami                     = var.ami
  aws_instance_type       = var.aws_instance_type

  cluster_name           = var.cluster_name
  rke_kubernetes_version = var.rke_kubernetes_version
  worker_node_pool_name  = var.worker_node_pool_name
  master_node_pool_name  = var.master_node_pool_name
  master_hostname_prefix = var.master_hostname_prefix
  worker_hostname_prefix = var.worker_hostname_prefix
  master_quantity        = var.master_quantity
  worker_quantity        = var.worker_quantity

}
