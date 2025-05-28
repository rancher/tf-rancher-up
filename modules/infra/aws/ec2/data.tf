# TODO: Add support for ARM architecture
data "aws_ssm_parameter" "sles" {
  name = "/aws/service/suse/sles-byos/${var.sles_version}/x86_64/latest"
}

data "aws_ssm_parameter" "ubuntu" {
  name = "/aws/service/canonical/ubuntu/server/${var.ubuntu_version}/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

data "aws_security_group" "sg" {
  count = var.create_security_group ? 0 : 1
  id    = var.instance_security_group
}

data "aws_vpc" "default_vpc" {
  count   = var.create_vpc != true ? 1 : 0
  default = true
}

data "aws_subnets" "default_subnets" {
  count = var.create_vpc != true ? 1 : 0
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc[0].id]
  }
}

data "http" "client_public_ip" {
  count = var.restricted_access == true ? 1 : 0
  url   = "http://icanhazip.com"
}