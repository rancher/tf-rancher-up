# TODO: Make the Ubuntu OS version configurable
# TODO: Add support for ARM architecture
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "sles" {
  most_recent = true
  owners      = ["679593333241"] # SUSE

  filter {
    name   = "name"
    values = ["suse-sles-15-sp6-byos-*-hvm-ssd-x86_64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}