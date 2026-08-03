provider "aws" {
  access_key = var.aws_access_key != null ? var.aws_access_key : null
  secret_key = var.aws_secret_key != null ? var.aws_secret_key : null
  region     = var.aws_region
}