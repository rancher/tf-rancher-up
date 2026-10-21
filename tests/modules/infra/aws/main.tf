module "test1_all_defaults" {
  source = "../../../../modules/infra/aws/ec2"

  instance_count          = 1
  create_security_group   = false
  create_ssh_key_pair     = true
  ssh_username            = "ubuntu"
  instance_security_group = "default"
}

module "test2_specify_sg" {
  source = "../../../../modules/infra/aws/ec2"

  instance_count          = 1
  create_security_group   = false
  create_ssh_key_pair     = true
  ssh_username            = "ubuntu"
  instance_security_group = "default"
}

resource "aws_vpc" "for_test3" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "for_test3" {
  vpc_id     = aws_vpc.for_test3.id
  cidr_block = "10.0.0.0/24"
}

resource "aws_security_group" "for_test3" {
  name   = "tf-rancher-up-test3"
  vpc_id = aws_vpc.for_test3.id
}

module "test3_specify_dynamic_vpc" {
  source = "../../../../modules/infra/aws/ec2"

  instance_count          = 1
  create_ssh_key_pair     = true
  ssh_username            = "ubuntu"
  create_security_group   = false
  instance_security_group = aws_security_group.for_test3.id
  vpc_id                  = aws_vpc.for_test3.id
  subnet_id               = aws_subnet.for_test3.id
  lookup_default_vpc      = false
}
