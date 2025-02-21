locals {
  availability_zones = slice(data.aws_availability_zones.azs.names, 0, 3)
  private_subnets    = [for i in range(length(local.availability_zones)) : cidrsubnet(var.vpc_cidr, 8, i + 100)]
  public_subnets     = [for i in range(length(local.availability_zones)) : cidrsubnet(var.vpc_cidr, 8, i + 200)]
}

module "vpc" {
  count  = var.vpc_cidr != null && var.public_subnets != null ? 1 : 0
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.prefix}-vpc"
  cidr = var.vpc_cidr

  azs                     = local.availability_zones
  private_subnets         = local.private_subnets
  public_subnets          = local.public_subnets
  map_public_ip_on_launch = true

  enable_nat_gateway     = var.private_subnets == null ? false : true
  single_nat_gateway     = var.private_subnets == null ? false : true
  one_nat_gateway_per_az = var.private_subnets == null ? false : false

  private_subnet_tags = merge(
    {
      Name    = "${var.prefix}-private-subnet"
      Creator = var.prefix
    },
    var.tags
  )
  public_subnet_tags = merge(
    {
      Name    = "${var.prefix}-public-subnet"
      Creator = var.prefix
    },
    var.tags
  )
  tags = merge(
    {
      Name    = "${var.prefix}-vpc"
      Creator = var.prefix
    },
    var.tags
  )
}