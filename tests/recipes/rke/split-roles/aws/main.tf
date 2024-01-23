module "test1_default" {
  source = "../../../../../recipes/rke/split-roles/aws"

  prefix              = "test1_default"
  aws_access_key      = var.aws_access_key
  aws_secret_key      = var.aws_secret_key
  aws_region          = "us-west-2"
  create_ssh_key_pair = true
}

module "test2_pass_existing_key" {
  source = "../../../../../recipes/rke/split-roles/aws"

  prefix              = "test1_default"
  aws_access_key      = var.aws_access_key
  aws_secret_key      = var.aws_secret_key
  aws_region          = "us-west-2"
  create_ssh_key_pair = true
  ssh_key_pair_name   = "junk"
  ssh_key_pair_path   = "~/somepath"
}
