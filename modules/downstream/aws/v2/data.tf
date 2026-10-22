data "aws_ssm_parameter" "sles" {
  count = var.ami == null && var.os_type == "sles" ? 1 : 0
  name  = "/aws/service/suse/sles-byos/${var.sles_version}/x86_64/latest"
}

data "aws_ssm_parameter" "ubuntu" {
  count = var.ami == null && var.os_type == "ubuntu" ? 1 : 0
  name  = "/aws/service/canonical/ubuntu/server/${var.ubuntu_version}/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

locals {
  # The global subnet only applies to pools that do not set their own.
  provided_subnet_ids = distinct(compact(concat(
    [for pool in local.custom_machine_pools : pool.subnet_id],
    anytrue([for pool in local.custom_machine_pools : pool.subnet_id == null]) ? [var.subnet_id] : []
  )))

  need_default_vpc_lookup = local.use_custom_machine_pools && var.vpc_id == null && length(local.provided_subnet_ids) == 0

  need_subnet_lookup = local.use_custom_machine_pools && var.subnet_id == null && anytrue([for pool in local.custom_machine_pools : pool.subnet_id == null])
}

# Use the plural data source so a missing default VPC returns an empty list
# instead of failing the plan in accounts where the default VPC was deleted.
data "aws_vpcs" "default" {
  count = local.need_default_vpc_lookup ? 1 : 0

  filter {
    # Documented EC2 DescribeVpcs filter name:
    # https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeVpcs.html
    name   = "is-default"
    values = ["true"]
  }
}

# Look up every subnet given to the pool configuration. Their AZ and VPC are
# needed for zone resolution and for validating the pool placement.
data "aws_subnet" "provided" {
  for_each = local.use_custom_machine_pools ? toset(local.provided_subnet_ids) : toset([])
  id       = each.value
}

locals {
  provided_subnet_vpc_ids = distinct([for subnet in data.aws_subnet.provided : subnet.vpc_id])
  default_vpc_id          = try(tolist(data.aws_vpcs.default[0].ids)[0], null)

  effective_vpc_id = var.vpc_id != null ? var.vpc_id : (
    length(local.provided_subnet_vpc_ids) == 1 ? local.provided_subnet_vpc_ids[0] : (
      length(local.provided_subnet_vpc_ids) == 0 ? local.default_vpc_id : null
    )
  )
}

data "aws_subnets" "selected" {
  count = local.need_subnet_lookup && local.effective_vpc_id != null ? 1 : 0

  filter {
    name   = "vpc-id"
    values = [local.effective_vpc_id]
  }
}

data "aws_subnet" "discovered" {
  for_each = local.need_subnet_lookup && local.effective_vpc_id != null ? toset(try(data.aws_subnets.selected[0].ids, [])) : toset([])
  id       = each.value
}

locals {
  subnet_details = merge(
    { for subnet in data.aws_subnet.provided : subnet.id => subnet },
    { for subnet in data.aws_subnet.discovered : subnet.id => subnet }
  )

  zone_suffix_by_subnet = {
    for id, subnet in local.subnet_details : id => regex("([a-z])$", subnet.availability_zone)[0]
  }

  subnet_ids_by_zone = {
    for zone in distinct(values(local.zone_suffix_by_subnet)) :
    zone => sort([for id, subnet_zone in local.zone_suffix_by_subnet : id if subnet_zone == zone])
  }
}
