data "aws_ssm_parameter" "sles" {
  count = var.ami == null && var.os_type == "sles" ? 1 : 0
  name  = "/aws/service/suse/sles-byos/${var.sles_version}/x86_64/latest"
}

data "aws_ssm_parameter" "ubuntu" {
  count = var.ami == null && var.os_type == "ubuntu" ? 1 : 0
  name  = "/aws/service/canonical/ubuntu/server/${var.ubuntu_version}/stable/current/amd64/hvm/ebs-gp3/ami-id"
}