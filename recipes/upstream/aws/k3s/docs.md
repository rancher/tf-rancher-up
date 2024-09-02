## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.53.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.10.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0.0 |
| <a name="requirement_ssh"></a> [ssh](#requirement\_ssh) | 2.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_ssh"></a> [ssh](#provider\_ssh) | 2.6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_k3s_additional"></a> [k3s\_additional](#module\_k3s\_additional) | ../../../../modules/distribution/k3s | n/a |
| <a name="module_k3s_additional_servers"></a> [k3s\_additional\_servers](#module\_k3s\_additional\_servers) | ../../../../modules/infra/aws/ec2 | n/a |
| <a name="module_k3s_additional_workers"></a> [k3s\_additional\_workers](#module\_k3s\_additional\_workers) | ../../../../modules/infra/aws/ec2 | n/a |
| <a name="module_k3s_first"></a> [k3s\_first](#module\_k3s\_first) | ../../../../modules/distribution/k3s | n/a |
| <a name="module_k3s_first_server"></a> [k3s\_first\_server](#module\_k3s\_first\_server) | ../../../../modules/infra/aws/ec2 | n/a |
| <a name="module_rancher_install"></a> [rancher\_install](#module\_rancher\_install) | ../../../../modules/rancher | n/a |

## Resources

| Name | Type |
|------|------|
| [local_file.kube_config_yaml](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.wait_k8s_services_startup](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [ssh_resource.retrieve_kubeconfig](https://registry.terraform.io/providers/loafoe/ssh/2.6.0/docs/resources/resource) | resource |
| [local_file.ssh_private_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | AWS access key used to create infrastructure | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region used for all resources | `string` | `"us-east-1"` | no |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | AWS secret key used to create AWS infrastructure | `string` | `null` | no |
| <a name="input_bootstrap_rancher"></a> [bootstrap\_rancher](#input\_bootstrap\_rancher) | Bootstrap the Rancher installation | `bool` | `true` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | Should create the security group associated with the instance(s) | `bool` | `null` | no |
| <a name="input_create_ssh_key_pair"></a> [create\_ssh\_key\_pair](#input\_create\_ssh\_key\_pair) | Specify if a new SSH key pair needs to be created for the instances | `bool` | `null` | no |
| <a name="input_create_vpc"></a> [create\_vpc](#input\_create\_vpc) | Specify whether VPC / Subnet should be created for the instances | `bool` | `null` | no |
| <a name="input_instance_disk_size"></a> [instance\_disk\_size](#input\_instance\_disk\_size) | Specify root disk size (GB) | `string` | `"80"` | no |
| <a name="input_instance_security_group_id"></a> [instance\_security\_group\_id](#input\_instance\_security\_group\_id) | Provide a pre-existing security group ID | `string` | `null` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type used for all EC2 instances | `string` | `"t3.medium"` | no |
| <a name="input_k3s_channel"></a> [k3s\_channel](#input\_k3s\_channel) | K3s channel to use, the latest patch version for the provided minor version will be used | `string` | `null` | no |
| <a name="input_k3s_config"></a> [k3s\_config](#input\_k3s\_config) | Additional K3S configuration to add to the config.yaml file | `any` | `null` | no |
| <a name="input_k3s_token"></a> [k3s\_token](#input\_k3s\_token) | Token to use when configuring K3S nodes | `any` | `null` | no |
| <a name="input_k3s_version"></a> [k3s\_version](#input\_k3s\_version) | Kubernetes version to use for the K3S cluster | `string` | `"v1.28.9+k3s1"` | no |
| <a name="input_kube_config_filename"></a> [kube\_config\_filename](#input\_kube\_config\_filename) | Filename to write the kube config | `string` | `null` | no |
| <a name="input_kube_config_path"></a> [kube\_config\_path](#input\_kube\_config\_path) | The path to write the kubeconfig for the RKE cluster | `string` | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix added to names of all resources | `string` | `null` | no |
| <a name="input_rancher_hostname"></a> [rancher\_hostname](#input\_rancher\_hostname) | n/a | `any` | n/a | yes |
| <a name="input_rancher_ingress_class_name"></a> [rancher\_ingress\_class\_name](#input\_rancher\_ingress\_class\_name) | Rancher ingressClassName value | `string` | `"traefik"` | no |
| <a name="input_rancher_password"></a> [rancher\_password](#input\_rancher\_password) | n/a | `string` | n/a | yes |
| <a name="input_rancher_service_type"></a> [rancher\_service\_type](#input\_rancher\_service\_type) | Rancher serviceType value | `string` | `"ClusterIP"` | no |
| <a name="input_rancher_version"></a> [rancher\_version](#input\_rancher\_version) | Rancher version to install | `string` | `null` | no |
| <a name="input_server_nodes_count"></a> [server\_nodes\_count](#input\_server\_nodes\_count) | The number of Server nodes | `number` | `3` | no |
| <a name="input_spot_instances"></a> [spot\_instances](#input\_spot\_instances) | Use spot instances | `bool` | `false` | no |
| <a name="input_ssh_key_pair_name"></a> [ssh\_key\_pair\_name](#input\_ssh\_key\_pair\_name) | If you want to use an existing key pair, specify its name | `string` | `null` | no |
| <a name="input_ssh_private_key_path"></a> [ssh\_private\_key\_path](#input\_ssh\_private\_key\_path) | The full path where is present the pre-generated SSH PRIVATE key (not generated by Terraform) | `string` | `null` | no |
| <a name="input_ssh_public_key_path"></a> [ssh\_public\_key\_path](#input\_ssh\_public\_key\_path) | The full path where is present the pre-generated SSH PUBLIC key (not generated by Terraform) | `any` | `null` | no |
| <a name="input_ssh_username"></a> [ssh\_username](#input\_ssh\_username) | Username used for SSH with sudo access | `string` | `"ubuntu"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | VPC Subnet ID to create the instance(s) in | `string` | `null` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | User data content for EC2 instance(s) | `any` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID to create the instance(s) in | `string` | `null` | no |
| <a name="input_waiting_time"></a> [waiting\_time](#input\_waiting\_time) | Waiting time (in seconds) | `number` | `180` | no |
| <a name="input_worker_nodes_count"></a> [worker\_nodes\_count](#input\_worker\_nodes\_count) | The number of Worker nodes | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rancher_password"></a> [rancher\_password](#output\_rancher\_password) | Rancher Initial Custom Password |
| <a name="output_rancher_url"></a> [rancher\_url](#output\_rancher\_url) | Rancher URL |
