module "aws-ec2-upstream-master-nodes" {
  source         = "../../../../../modules/infra/aws/ec2"
  prefix         = var.prefix
  aws_region     = var.aws_region
  instance_count = var.server_nodes_count
  ssh_username   = var.ssh_username
}

module "aws-ec2-upstream-worker-nodes" {
  source         = "../../../../../modules/infra/aws/ec2"
  prefix         = "${var.prefix}-w"
  aws_region     = var.aws_region
  instance_count = var.worker_nodes_count
  ssh_username   = var.ssh_username
}
