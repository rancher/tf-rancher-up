# TODO: Add support for ARM architecture
data "aws_ssm_parameter" "sles" {
  name = "/aws/service/suse/sles-byos/${var.sles_version}/x86_64/latest"
}

data "aws_ssm_parameter" "ubuntu" {
  name = "/aws/service/canonical/ubuntu/server/${var.ubuntu_version}/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

data "aws_security_group" "sg" {
  count = var.create_security_group ? 0 : 1
  id    = var.instance_security_group
}

locals {
  should_lookup_default_vpc = var.create_vpc != true && var.lookup_default_vpc && var.subnet_id == null
  default_vpc_ids           = local.should_lookup_default_vpc ? tolist(data.aws_vpcs.default_vpcs[0].ids) : tolist([])
  default_vpc_available     = length(local.default_vpc_ids) > 0
}

# Use the plural data source so a missing default VPC returns an empty list
# instead of failing the plan in accounts where the default VPC was deleted.
data "aws_vpcs" "default_vpcs" {
  count = local.should_lookup_default_vpc ? 1 : 0

  filter {
    name   = "isDefault"
    values = ["true"]
  }
}

data "aws_subnets" "default_subnets" {
  count = local.default_vpc_available ? 1 : 0

  filter {
    name   = "vpc-id"
    values = local.default_vpc_ids
  }
}

data "aws_subnet" "default" {
  for_each = local.default_vpc_available ? toset(data.aws_subnets.default_subnets[0].ids) : toset([])
  id       = each.value
}

data "aws_subnet" "provided" {
  count = var.create_vpc != true && var.vpc_id == null && var.create_security_group && var.subnet_id != null ? 1 : 0
  id    = local.provided_subnets[0]
}

data "http" "client_public_ip" {
  count = var.restricted_access == true ? 1 : 0
  url   = "http://ipv4.icanhazip.com"
}
