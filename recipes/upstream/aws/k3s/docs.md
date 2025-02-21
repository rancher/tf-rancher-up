## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_ssh"></a> [ssh](#requirement\_ssh) | 2.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_ssh"></a> [ssh](#provider\_ssh) | 2.7.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_k3s_additional"></a> [k3s\_additional](#module\_k3s\_additional) | ../../../../modules/distribution/k3s | n/a |
| <a name="module_k3s_additional_servers"></a> [k3s\_additional\_servers](#module\_k3s\_additional\_servers) | ../../../../modules/infra/aws/ec2 | n/a |
| <a name="module_k3s_first"></a> [k3s\_first](#module\_k3s\_first) | ../../../../modules/distribution/k3s | n/a |
| <a name="module_k3s_first_server"></a> [k3s\_first\_server](#module\_k3s\_first\_server) | ../../../../modules/infra/aws/ec2 | n/a |
| <a name="module_k3s_workers"></a> [k3s\_workers](#module\_k3s\_workers) | ../../../../modules/infra/aws/ec2 | n/a |
| <a name="module_rancher_install"></a> [rancher\_install](#module\_rancher\_install) | ../../../../modules/rancher | n/a |

## Resources

| Name | Type |
|------|------|
| [local_file.kube_config_yaml](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.kube_config_yaml_backup](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [ssh_resource.retrieve_kubeconfig](https://registry.terraform.io/providers/loafoe/ssh/2.7.0/docs/resources/resource) | resource |
| [local_file.ssh_private_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | AWS access key used to create infrastructure | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region used for all resources | `string` | `"us-east-1"` | no |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | AWS secret key used to create AWS infrastructure | `string` | `null` | no |
| <a name="input_cert_manager_helm_repository"></a> [cert\_manager\_helm\_repository](#input\_cert\_manager\_helm\_repository) | Helm repository for Cert Manager chart | `string` | `null` | no |
| <a name="input_cert_manager_helm_repository_password"></a> [cert\_manager\_helm\_repository\_password](#input\_cert\_manager\_helm\_repository\_password) | Private Cert Manager helm repository password | `string` | `null` | no |
| <a name="input_cert_manager_helm_repository_username"></a> [cert\_manager\_helm\_repository\_username](#input\_cert\_manager\_helm\_repository\_username) | Private Cert Manager helm repository username | `string` | `null` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | Create the security group attached to the instance(s) | `bool` | `true` | no |
| <a name="input_create_ssh_key_pair"></a> [create\_ssh\_key\_pair](#input\_create\_ssh\_key\_pair) | Specify if a new SSH key pair needs to be created for the instances | `bool` | `null` | no |
| <a name="input_create_vpc"></a> [create\_vpc](#input\_create\_vpc) | Create a VPC | `any` | `null` | no |
| <a name="input_instance_ami"></a> [instance\_ami](#input\_instance\_ami) | Override the default SLES or Ubuntu AMI | `string` | `null` | no |
| <a name="input_instance_disk_size"></a> [instance\_disk\_size](#input\_instance\_disk\_size) | Specify root disk size (GB) | `string` | `null` | no |
| <a name="input_instance_security_group"></a> [instance\_security\_group](#input\_instance\_security\_group) | Provide a pre-existing security group ID to attach to the instance(s) | `string` | `null` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type used for all EC2 instances | `string` | `null` | no |
| <a name="input_k3s_channel"></a> [k3s\_channel](#input\_k3s\_channel) | K3s channel to use, the latest patch version for the provided minor version will be used | `string` | `null` | no |
| <a name="input_k3s_config"></a> [k3s\_config](#input\_k3s\_config) | Additional k3s configuration to add to the config.yaml file | `any` | `null` | no |
| <a name="input_k3s_token"></a> [k3s\_token](#input\_k3s\_token) | Token to use when configuring k3s nodes | `any` | `null` | no |
| <a name="input_k3s_version"></a> [k3s\_version](#input\_k3s\_version) | Kubernetes version to use for the k3s cluster | `string` | `null` | no |
| <a name="input_kube_config_filename"></a> [kube\_config\_filename](#input\_kube\_config\_filename) | Filename to write the kube config | `string` | `null` | no |
| <a name="input_kube_config_path"></a> [kube\_config\_path](#input\_kube\_config\_path) | The path to write the kubeconfig for the RKE cluster | `string` | `null` | no |
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | Use SLES or Ubuntu images when launching instances (sles or ubuntu) | `string` | `"sles"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix added to names of all resources | `string` | `null` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | Create Public subnets for VPC | `any` | `null` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | Create Public subnets for VPC | `bool` | `true` | no |
| <a name="input_rancher_bootstrap_password"></a> [rancher\_bootstrap\_password](#input\_rancher\_bootstrap\_password) | Password to use when bootstrapping Rancher (min 12 characters) | `string` | `"initial-bootstrap-password"` | no |
| <a name="input_rancher_helm_repository"></a> [rancher\_helm\_repository](#input\_rancher\_helm\_repository) | Helm repository for Rancher chart | `string` | `null` | no |
| <a name="input_rancher_helm_repository_password"></a> [rancher\_helm\_repository\_password](#input\_rancher\_helm\_repository\_password) | Private Rancher helm repository password | `string` | `null` | no |
| <a name="input_rancher_helm_repository_username"></a> [rancher\_helm\_repository\_username](#input\_rancher\_helm\_repository\_username) | Private Rancher helm repository username | `string` | `null` | no |
| <a name="input_rancher_password"></a> [rancher\_password](#input\_rancher\_password) | Password for the Rancher admin account (min 12 characters) | `string` | `null` | no |
| <a name="input_rancher_replicas"></a> [rancher\_replicas](#input\_rancher\_replicas) | Value for replicas when installing the Rancher helm chart | `number` | `3` | no |
| <a name="input_rancher_version"></a> [rancher\_version](#input\_rancher\_version) | Rancher version to install | `string` | `null` | no |
| <a name="input_server_instance_count"></a> [server\_instance\_count](#input\_server\_instance\_count) | Number of server EC2 instances to create | `number` | `null` | no |
| <a name="input_sles_version"></a> [sles\_version](#input\_sles\_version) | Version of SLES to use for instances (ex: 15-sp6) | `string` | `"15-sp6"` | no |
| <a name="input_spot_instances"></a> [spot\_instances](#input\_spot\_instances) | Use spot instances | `bool` | `null` | no |
| <a name="input_ssh_key_pair_name"></a> [ssh\_key\_pair\_name](#input\_ssh\_key\_pair\_name) | Specify the SSH key name to use (that's already present in AWS) | `string` | `null` | no |
| <a name="input_ssh_key_pair_path"></a> [ssh\_key\_pair\_path](#input\_ssh\_key\_pair\_path) | Path to the SSH private key used as the key pair (that's already present in AWS) | `string` | `null` | no |
| <a name="input_ssh_username"></a> [ssh\_username](#input\_ssh\_username) | Username used for SSH with sudo access, must align with the AMI in use | `string` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | VPC Subnet ID to create the instance(s) in | `any` | `null` | no |
| <a name="input_ubuntu_version"></a> [ubuntu\_version](#input\_ubuntu\_version) | Version of Ubuntu to use for instances (ex: 22.04) | `string` | `"22.04"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR for AWS VPC | `string` | `"10.0.0.0/16"` | no |
| <a name="input_wait"></a> [wait](#input\_wait) | An optional wait before installing the Rancher helm chart | `string` | `"20s"` | no |
| <a name="input_worker_instance_count"></a> [worker\_instance\_count](#input\_worker\_instance\_count) | Number of worker EC2 instances to create | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instances_private_ip"></a> [instances\_private\_ip](#output\_instances\_private\_ip) | n/a |
| <a name="output_instances_public_ip"></a> [instances\_public\_ip](#output\_instances\_public\_ip) | n/a |
| <a name="output_rancher_admin_token"></a> [rancher\_admin\_token](#output\_rancher\_admin\_token) | Rancher API token for the admin user |
| <a name="output_rancher_hostname"></a> [rancher\_hostname](#output\_rancher\_hostname) | n/a |
| <a name="output_rancher_password"></a> [rancher\_password](#output\_rancher\_password) | n/a |
| <a name="output_rancher_url"></a> [rancher\_url](#output\_rancher\_url) | n/a |
