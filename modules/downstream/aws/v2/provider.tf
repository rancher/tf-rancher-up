locals {
  # Machine pool subnet/AZ lookups always need real AWS credentials, so only
  # mock credentials for the legacy pools when the AMI is pinned.
  mock_aws_credentials = var.ami != null && !local.use_custom_machine_pools
}

provider "aws" {
  region                      = var.aws_region
  access_key                  = var.aws_access_key != null ? var.aws_access_key : (local.mock_aws_credentials ? "mock" : null)
  secret_key                  = var.aws_secret_key != null ? var.aws_secret_key : (local.mock_aws_credentials ? "mock" : null)
  skip_credentials_validation = local.mock_aws_credentials
  skip_requesting_account_id  = local.mock_aws_credentials
}
