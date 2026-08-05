provider "aws" {
  region                      = var.aws_region
  access_key                  = var.aws_access_key != null ? var.aws_access_key : (var.ami != null ? "mock" : null)
  secret_key                  = var.aws_secret_key != null ? var.aws_secret_key : (var.ami != null ? "mock" : null)
  skip_credentials_validation = var.ami != null ? true : false
  skip_requesting_account_id  = var.ami != null ? true : false
}