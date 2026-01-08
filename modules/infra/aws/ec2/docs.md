## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.46 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.46 |
| <a name="provider_http"></a> [http](#provider\_http) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_vpc"></a> [aws\_vpc](#module\_aws\_vpc) | ../vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_instance.instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.key_pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_security_group.sg_allowall](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [local_file.private_key_pem](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [random_shuffle.subnet](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/shuffle) | resource |
| [tls_private_key.ssh_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_security_group.sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |
| [aws_ssm_parameter.sles](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_subnets.default_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.default_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [http_http.client_public_ip](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | AWS access key used to create infrastructure | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region used for all resources | `string` | `"us-east-1"` | no |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | AWS secret key used to create AWS infrastructure | `string` | `null` | no |
| <a name="input_bastion_host"></a> [bastion\_host](#input\_bastion\_host) | Bastion host configuration to access the instances | <pre>object({<br>    address      = string<br>    user         = string<br>    ssh_key      = string<br>    ssh_key_path = string<br>  })</pre> | `null` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | Create the security group attached to the instance(s) | `bool` | `true` | no |
| <a name="input_create_ssh_key_pair"></a> [create\_ssh\_key\_pair](#input\_create\_ssh\_key\_pair) | Specify if a new SSH key pair needs to be created for the instances | `bool` | `true` | no |
| <a name="input_create_vpc"></a> [create\_vpc](#input\_create\_vpc) | Create a VPC | `bool` | `false` | no |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | Specify IAM Instance Profile to assign to the instances/nodes | `string` | `null` | no |
| <a name="input_instance_ami"></a> [instance\_ami](#input\_instance\_ami) | Override the default SLES or Ubuntu AMI | `string` | `null` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of EC2 instances to create | `number` | `0` | no |
| <a name="input_instance_disk_size"></a> [instance\_disk\_size](#input\_instance\_disk\_size) | Specify root disk size (GB) | `string` | `"80"` | no |
| <a name="input_instance_security_group"></a> [instance\_security\_group](#input\_instance\_security\_group) | Provide a pre-existing security group ID to attach to the instance(s) | `string` | `null` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type used for all EC2 instances | `string` | `"t3.medium"` | no |
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | Use SLES or Ubuntu images when launching instances (sles or ubuntu) | `string` | `"sles"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix added to names of all resources | `string` | `"rancher-terraform"` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | Create Public subnets for VPC | `any` | `null` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | Create Public subnets for VPC | `bool` | `true` | no |
| <a name="input_restricted_access"></a> [restricted\_access](#input\_restricted\_access) | Restrict access to SSH and kube-apiserver ports when creating the security group, allowing only the public IP of the client running terraform | `bool` | `false` | no |
| <a name="input_sles_version"></a> [sles\_version](#input\_sles\_version) | Version of SLES to use for instances (ex: 15-sp6) | `string` | `"15-sp6"` | no |
| <a name="input_spot_instances"></a> [spot\_instances](#input\_spot\_instances) | Use spot instances | `bool` | `false` | no |
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | Contents of the private key to connect to the instances. | `string` | `null` | no |
| <a name="input_ssh_key_pair_name"></a> [ssh\_key\_pair\_name](#input\_ssh\_key\_pair\_name) | Specify the SSH key name to use (that's already present in AWS) | `string` | `null` | no |
| <a name="input_ssh_key_pair_path"></a> [ssh\_key\_pair\_path](#input\_ssh\_key\_pair\_path) | Path to the SSH private key used as the key pair (that's already present in AWS) | `string` | `null` | no |
| <a name="input_ssh_private_key_path"></a> [ssh\_private\_key\_path](#input\_ssh\_private\_key\_path) | Path to write the generated SSH private key | `string` | `null` | no |
| <a name="input_ssh_username"></a> [ssh\_username](#input\_ssh\_username) | Username used for SSH with sudo access | `string` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | VPC Subnet ID to create the instance(s) in | `any` | `null` | no |
| <a name="input_tag_begin"></a> [tag\_begin](#input\_tag\_begin) | When module is being called mode than once, begin tagging from this number | `number` | `1` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | User-provided tags for the resources | `map(string)` | `{}` | no |
| <a name="input_ubuntu_version"></a> [ubuntu\_version](#input\_ubuntu\_version) | Version of Ubuntu to use for instances (ex: 22.04) | `string` | `"22.04"` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | User data content for EC2 instance(s) | `any` | `null` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR for AWS VPC | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_public_ip"></a> [client\_public\_ip](#output\_client\_public\_ip) | n/a |
| <a name="output_dependency"></a> [dependency](#output\_dependency) | n/a |
| <a name="output_instance_ips"></a> [instance\_ips](#output\_instance\_ips) | n/a |
| <a name="output_instances_private_ip"></a> [instances\_private\_ip](#output\_instances\_private\_ip) | n/a |
| <a name="output_instances_public_ip"></a> [instances\_public\_ip](#output\_instances\_public\_ip) | n/a |
| <a name="output_node_username"></a> [node\_username](#output\_node\_username) | n/a |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | n/a |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | n/a |
| <a name="output_sg-id"></a> [sg-id](#output\_sg-id) | n/a |
| <a name="output_ssh_key_pair_name"></a> [ssh\_key\_pair\_name](#output\_ssh\_key\_pair\_name) | n/a |
| <a name="output_ssh_key_path"></a> [ssh\_key\_path](#output\_ssh\_key\_path) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |
