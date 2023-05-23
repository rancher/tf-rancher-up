
module "upstream_cluster" {
  source         = "../"
  aws_region     = "us-east-1"
  prefix         = "example-rancher"
  instance_count = 1
  #  create_ssh_key_pair = true
}