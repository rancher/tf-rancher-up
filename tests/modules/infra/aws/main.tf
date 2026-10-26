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
  vpc_id                  = aws_vpc.for_test3.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "for_test3" {
  vpc_id = aws_vpc.for_test3.id
}

resource "aws_route_table" "for_test3" {
  vpc_id = aws_vpc.for_test3.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.for_test3.id
  }
}

resource "aws_route_table_association" "for_test3" {
  subnet_id      = aws_subnet.for_test3.id
  route_table_id = aws_route_table.for_test3.id
}

data "http" "client_public_ip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "for_test3" {
  name        = "tf-rancher-up-test3"
  description = "Allow SSH for the EC2 module remote-exec test"
  vpc_id      = aws_vpc.for_test3.id

  ingress {
    description = "SSH from the machine running Terraform"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.client_public_ip.response_body)}/32"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
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
