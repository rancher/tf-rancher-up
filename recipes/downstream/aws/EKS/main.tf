module "downstream_eks" {
  source = "../../../../modules/downstream/aws/EKS/"

  aws_access_key      = var.aws_access_key
  aws_secret_key      = var.aws_secret_key
  cloud_credential_id = var.cloud_credential_id
  aws_region          = var.aws_region
  cluster_name        = var.cluster_name
  kubernetes_version  = var.kubernetes_version
  node_groups         = var.node_groups
  cluster_description = var.cluster_description
}