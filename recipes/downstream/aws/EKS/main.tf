module "downstream_eks" {
  source = "../../../../modules/downstream/aws/EKS/"

  rancher_api_url              = var.rancher_api_url
  rancher_access_key           = var.rancher_access_key
  rancher_secret_key           = var.rancher_secret_key
  aws_access_key               = var.aws_access_key
  aws_secret_key               = var.aws_secret_key
  cloud_credential_name        = var.cloud_credential_name
  cloud_credential_description = var.cloud_credential_description
  cluster_name                 = var.cluster_name
  kubernetes_version           = var.kubernetes_version
  aws_region                   = var.aws_region
  node_groups                  = var.node_groups
}