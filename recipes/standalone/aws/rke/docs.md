## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cluster-nodes"></a> [cluster-nodes](#module\_cluster-nodes) | ../../../../modules/infra/aws/ec2 | n/a |
| <a name="module_rke"></a> [rke](#module\_rke) | ../../../../modules/distribution/rke | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | AWS access key used to create infrastructure | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region used for all resources | `string` | `"us-east-1"` | no |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | AWS secret key used to create AWS infrastructure | `string` | `null` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | Should create the security group associated with the instance(s) | `bool` | `null` | no |
| <a name="input_create_ssh_key_pair"></a> [create\_ssh\_key\_pair](#input\_create\_ssh\_key\_pair) | Specify if a new SSH key pair needs to be created for the instances | `bool` | `null` | no |
| <a name="input_dependency"></a> [dependency](#input\_dependency) | An optional variable to add a dependency from another resource (not used) | `any` | `null` | no |
| <a name="input_docker_version"></a> [docker\_version](#input\_docker\_version) | Docker version to install on nodes | `string` | `"20.10"` | no |
| <a name="input_install_docker"></a> [install\_docker](#input\_install\_docker) | Should install docker while creating the instance | `bool` | `true` | no |
| <a name="input_instance_ami"></a> [instance\_ami](#input\_instance\_ami) | Override the default SLES or Ubuntu AMI | `string` | `null` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of EC2 instances to create | `number` | `null` | no |
| <a name="input_instance_disk_size"></a> [instance\_disk\_size](#input\_instance\_disk\_size) | Specify root disk size (GB) | `string` | `null` | no |
| <a name="input_instance_security_group"></a> [instance\_security\_group](#input\_instance\_security\_group) | Provide a pre-existing security group ID | `string` | `null` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type used for all EC2 instances | `string` | `null` | no |
| <a name="input_kube_config_filename"></a> [kube\_config\_filename](#input\_kube\_config\_filename) | Filename to write the kube config | `string` | `null` | no |
| <a name="input_kube_config_path"></a> [kube\_config\_path](#input\_kube\_config\_path) | The path to write the kubeconfig for the RKE cluster | `string` | `null` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version to use for the RKE cluster | `string` | `null` | no |
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | Use SLES or Ubuntu images when launching instances (sles or ubuntu) | `string` | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix added to names of all resources | `string` | `null` | no |
| <a name="input_spot_instances"></a> [spot\_instances](#input\_spot\_instances) | Use spot instances | `bool` | `null` | no |
| <a name="input_ssh_key_pair_name"></a> [ssh\_key\_pair\_name](#input\_ssh\_key\_pair\_name) | Specify the SSH key name to use (that's already present in AWS) | `string` | `null` | no |
| <a name="input_ssh_key_pair_path"></a> [ssh\_key\_pair\_path](#input\_ssh\_key\_pair\_path) | Path to the SSH private key used as the key pair (that's already present in AWS) | `string` | `null` | no |
| <a name="input_ssh_username"></a> [ssh\_username](#input\_ssh\_username) | Username used for SSH with sudo access, must align with the AMI in use | `string` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | VPC Subnet ID to create the instance(s) in | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dependency"></a> [dependency](#output\_dependency) | n/a |
| <a name="output_instances_private_ip"></a> [instances\_private\_ip](#output\_instances\_private\_ip) | n/a |
| <a name="output_instances_public_ip"></a> [instances\_public\_ip](#output\_instances\_public\_ip) | n/a |
| <a name="output_kubeconfig_filename"></a> [kubeconfig\_filename](#output\_kubeconfig\_filename) | n/a |
| <a name="output_kubeconfig_yaml"></a> [kubeconfig\_yaml](#output\_kubeconfig\_yaml) | n/a |
