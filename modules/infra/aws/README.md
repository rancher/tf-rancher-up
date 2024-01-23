# Terraform | AWS Infrastructure

Terraform module to provide AWS nodes prepared for creating a kubernetes cluster.

Basic infrastructure options are provided to be coupled with other modules for example environments.

Documentation can be found [here](./docs.md).

## Examples

#### Launch a single instance, create a keypair

```terraform
module "upstream_cluster" {
  source              = "git::https://github.com/rancherlabs/tf-rancher-up.git//modules/infra/aws"
  aws_region          = "us-east-1"
  prefix              = "example-rancher"
  instance_count      = 1
  create_ssh_key_pair = true
  user_data           = |
    echo "hello world"
}
```

#### Provide an existing SSH key and Security Group

```terraform
module "upstream_cluster" {
  source                  = "git::https://github.com/rancherlabs/tf-rancher-up.git//modules/infra/aws"
  aws_region              = "us-east-1"
  prefix                  = "example-rancher"
  instance_count          = 1
  ssh_key_pair_name       = "rancher-ssh"
  instance_security_group = "sg-xxxxx"
}
```

#### Provide an existing VPC and Subnet

```terraform
module "upstream_cluster" {
  source                  = "git::https://github.com/rancherlabs/tf-rancher-up.git//modules/infra/aws"
  aws_region              = "us-east-1"
  prefix                  = "example-rancher"
  instance_count          = 1
  vpc_id                  = "vpc-xxxxx"
	subnet_id               = "subnet-xxxxxx"
}
```
