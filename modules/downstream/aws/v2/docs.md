## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_rancher2"></a> [rancher2](#requirement\_rancher2) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_rancher2"></a> [rancher2](#provider\_rancher2) | >= 3.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [rancher2_cloud_credential.aws_credential](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cloud_credential) | resource |
| [rancher2_cluster_v2.cluster](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster_v2) | resource |
| [rancher2_machine_config_v2.machine_config](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/machine_config_v2) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami"></a> [ami](#input\_ami) | AMI to use when launching nodes | `any` | `null` | no |
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | AWS access key used to create infrastructure | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region used for all resources | `string` | `"us-west-2"` | no |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | AWS secret key used to create AWS infrastructure | `string` | `null` | no |
| <a name="input_cloud_credential_id"></a> [cloud\_credential\_id](#input\_cloud\_credential\_id) | Rancher cloud credential to use, instead of AWS access/secret key (ex: cattle-global-data:cc-xxx) | `string` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The cluster name | `string` | `"v2-ds"` | no |
| <a name="input_cni_provider"></a> [cni\_provider](#input\_cni\_provider) | CNI provider to use | `string` | `"calico"` | no |
| <a name="input_cp_count"></a> [cp\_count](#input\_cp\_count) | Control plane pool node count | `number` | `1` | no |
| <a name="input_cp_node_pool_name"></a> [cp\_node\_pool\_name](#input\_cp\_node\_pool\_name) | Control plane pool name | `string` | `"cp"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type used for all EC2 instances | `string` | `"t3a.medium"` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version to use for the RKE2/k3s cluster | `string` | `null` | no |
| <a name="input_rancher_insecure"></a> [rancher\_insecure](#input\_rancher\_insecure) | Allow insecure connections to Rancher | `bool` | `true` | no |
| <a name="input_rancher_token"></a> [rancher\_token](#input\_rancher\_token) | Rancher API token | `string` | `null` | no |
| <a name="input_rancher_url"></a> [rancher\_url](#input\_rancher\_url) | The Rancher server URL | `string` | `null` | no |
| <a name="input_security_group_name"></a> [security\_group\_name](#input\_security\_group\_name) | Security Group name for nodes | `any` | `null` | no |
| <a name="input_spot_instances"></a> [spot\_instances](#input\_spot\_instances) | Use spot instances | `bool` | `null` | no |
| <a name="input_ssh_user"></a> [ssh\_user](#input\_ssh\_user) | Username used for SSH with sudo access | `string` | `"ubuntu"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnet ID for all resources | `string` | `null` | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | Specify root volume size (GB) | `number` | `20` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | AWS VPC to use, subnet ID and security group must exist in the VPC | `string` | `null` | no |
| <a name="input_worker_count"></a> [worker\_count](#input\_worker\_count) | Worker pool node count | `number` | `1` | no |
| <a name="input_worker_node_pool_name"></a> [worker\_node\_pool\_name](#input\_worker\_node\_pool\_name) | Worker pool name | `string` | `"w"` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | AWS zone to use for all resources | `string` | `"a"` | no |

## Outputs

No outputs.
