module "test1_default" {
  source = "../../../../../recipes/upstream/aws/rke"

  prefix              = "test1_default"
  aws_access_key      = var.aws_access_key
  aws_secret_key      = var.aws_secret_key
  aws_region          = "us-west-2"
  create_ssh_key_pair = true
  rancher_password    = "this-is-an-insecure-password"
  instance_count      = 1
}
