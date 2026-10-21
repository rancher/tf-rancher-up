locals {
  # Only mock AWS credentials when an AMI is supplied and no AWS lookups are needed.
  # Subnet discovery requires real credentials even when the AMI is pinned.
  mock_aws_credentials = var.ami != null && !local.need_provided_subnet_lookup && !local.need_default_vpc_lookup && !local.need_subnet_lookup
}

provider "aws" {
  region                      = var.aws_region
  access_key                  = var.aws_access_key != null ? var.aws_access_key : (local.mock_aws_credentials ? "mock" : null)
  secret_key                  = var.aws_secret_key != null ? var.aws_secret_key : (local.mock_aws_credentials ? "mock" : null)
  skip_credentials_validation = local.mock_aws_credentials
  skip_requesting_account_id  = local.mock_aws_credentials
}
