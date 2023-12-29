module "test1_all_defaults" {
  source = "../../../../modules/infra/aws"

  instance_count          = 1
  create_security_group   = false
  create_ssh_key_pair     = true
  instance_security_group = "default"
}

module "test2_specify_sg" {
  source = "../../../../modules/infra/aws"

  instance_count          = 1
  create_security_group   = false
  create_ssh_key_pair     = true
  instance_security_group = "default"
}

resource "aws_vpc" "for_test3" {

}

module "test3_specify_dynamic_vpc" {
  source = "../../../../modules/infra/aws"

  instance_count      = 1
  create_ssh_key_pair = true
  vpc_id              = aws_vpc.for_test3.id
}
