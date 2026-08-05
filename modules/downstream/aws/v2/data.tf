provider "aws" {
  region                      = var.aws_region
  access_key                  = var.aws_access_key != null ? var.aws_access_key : (var.ami != null ? "mock" : null)
  secret_key                  = var.aws_secret_key != null ? var.aws_secret_key : (var.ami != null ? "mock" : null)
  skip_credentials_validation = var.ami != null ? true : false
  skip_requesting_account_id  = var.ami != null ? true : false
}

data "aws_ssm_parameter" "sles" {
  count = var.ami == null && var.os_type == "sles" ? 1 : 0
  name  = "/aws/service/suse/sles-byos/${var.sles_version}/x86_64/latest"
}

data "aws_ssm_parameter" "ubuntu" {
  count = var.ami == null && var.os_type == "ubuntu" ? 1 : 0
  name  = "/aws/service/canonical/ubuntu/server/${var.ubuntu_version}/stable/current/amd64/hvm/ebs-gp2/ami-id"
}