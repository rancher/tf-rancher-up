## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_master_nodes"></a> [master\_nodes](#module\_master\_nodes) | ../../../../modules/infra/aws | n/a |
| <a name="module_rke"></a> [rke](#module\_rke) | ../../../../modules/distribution/rke | n/a |
| <a name="module_worker_nodes"></a> [worker\_nodes](#module\_worker\_nodes) | ../../../../modules/infra/aws | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | Enter your AWS access key | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region used for all resources | `string` | n/a | yes |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | Enter your AWS secret key | `string` | n/a | yes |
| <a name="input_bastion_host"></a> [bastion\_host](#input\_bastion\_host) | Bastion host configuration to access the RKE nodes | <pre>object({<br>    address      = string<br>    user         = string<br>    ssh_key_path = string<br>    ssh_key      = string<br>  })</pre> | `null` | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | Specify the cloud provider name | `string` | `null` | no |
| <a name="input_create_kubeconfig_file"></a> [create\_kubeconfig\_file](#input\_create\_kubeconfig\_file) | Boolean flag to generate a kubeconfig file (mostly used for dev only) | `bool` | `true` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | Should create the security group associated with the instance(s) | `bool` | `true` | no |
| <a name="input_create_ssh_key_pair"></a> [create\_ssh\_key\_pair](#input\_create\_ssh\_key\_pair) | Specify if a new SSH key pair needs to be created for the instances | `bool` | `false` | no |
| <a name="input_dependency"></a> [dependency](#input\_dependency) | An optional variable to add a dependency from another resource (not used) | `any` | `null` | no |
| <a name="input_docker_version"></a> [docker\_version](#input\_docker\_version) | Docker version to install on nodes | `string` | `"23.0.6"` | no |
| <a name="input_install_docker"></a> [install\_docker](#input\_install\_docker) | Should install docker while creating the instance | `bool` | `true` | no |
| <a name="input_instance_security_group"></a> [instance\_security\_group](#input\_instance\_security\_group) | Provide a pre-existing security group ID | `string` | `null` | no |
| <a name="input_instance_security_group_name"></a> [instance\_security\_group\_name](#input\_instance\_security\_group\_name) | Provide a pre-existing security group name | `string` | `null` | no |
| <a name="input_kube_config_filename"></a> [kube\_config\_filename](#input\_kube\_config\_filename) | Filename to write the kube config | `string` | `null` | no |
| <a name="input_kube_config_path"></a> [kube\_config\_path](#input\_kube\_config\_path) | The path to write the kubeconfig for the RKE cluster | `string` | `null` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version to use for the RKE cluster | `string` | `null` | no |
| <a name="input_master_nodes_count"></a> [master\_nodes\_count](#input\_master\_nodes\_count) | Number of master nodes to create | `number` | `1` | no |
| <a name="input_master_nodes_iam_instance_profile"></a> [master\_nodes\_iam\_instance\_profile](#input\_master\_nodes\_iam\_instance\_profile) | Specify IAM instance profile to attach to master nodes | `string` | `null` | no |
| <a name="input_master_nodes_instance_disk_size"></a> [master\_nodes\_instance\_disk\_size](#input\_master\_nodes\_instance\_disk\_size) | Disk size used for all master nodes (in GB) | `string` | `"80"` | no |
| <a name="input_master_nodes_instance_type"></a> [master\_nodes\_instance\_type](#input\_master\_nodes\_instance\_type) | Instance type used for all master nodes | `string` | `"t3.medium"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix added to names of all resources | `string` | n/a | yes |
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | Contents of the private key to connect to the instances. | `string` | `null` | no |
| <a name="input_ssh_key_pair_name"></a> [ssh\_key\_pair\_name](#input\_ssh\_key\_pair\_name) | Specify the SSH key name to use (that's already present in AWS) | `string` | `null` | no |
| <a name="input_ssh_key_pair_path"></a> [ssh\_key\_pair\_path](#input\_ssh\_key\_pair\_path) | Path to the SSH private key used as the key pair (that's already present in AWS) | `string` | `null` | no |
| <a name="input_ssh_username"></a> [ssh\_username](#input\_ssh\_username) | Username used for SSH with sudo access | `string` | `"ubuntu"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | VPC Subnet ID to create the instance(s) in | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | User-provided tags for the resources | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID to create the instance(s) in | `string` | `null` | no |
| <a name="input_vpc_zone"></a> [vpc\_zone](#input\_vpc\_zone) | VPC zone | `string` | `null` | no |
| <a name="input_worker_nodes_count"></a> [worker\_nodes\_count](#input\_worker\_nodes\_count) | Number of worker nodes to create | `number` | `1` | no |
| <a name="input_worker_nodes_iam_instance_profile"></a> [worker\_nodes\_iam\_instance\_profile](#input\_worker\_nodes\_iam\_instance\_profile) | Specify IAM instance profile to attach to worker nodes | `string` | `null` | no |
| <a name="input_worker_nodes_instance_disk_size"></a> [worker\_nodes\_instance\_disk\_size](#input\_worker\_nodes\_instance\_disk\_size) | Disk size used for all worker nodes (in GB) | `string` | `"80"` | no |
| <a name="input_worker_nodes_instance_type"></a> [worker\_nodes\_instance\_type](#input\_worker\_nodes\_instance\_type) | Instance type used for all worker nodes | `string` | `"t3.large"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_credentials"></a> [credentials](#output\_credentials) | n/a |
| <a name="output_dependency"></a> [dependency](#output\_dependency) | n/a |
| <a name="output_kube_config_yaml"></a> [kube\_config\_yaml](#output\_kube\_config\_yaml) | n/a |
| <a name="output_kubeconfig_file"></a> [kubeconfig\_file](#output\_kubeconfig\_file) | n/a |
