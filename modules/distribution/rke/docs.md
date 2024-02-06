## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.1.0 |
| <a name="requirement_rke"></a> [rke](#requirement\_rke) | >= 1.4.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | >= 2.1.0 |
| <a name="provider_rke"></a> [rke](#provider\_rke) | >= 1.4.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [local_file.kube_config_yaml](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.kube_config_yaml_backup](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [rke_cluster.this](https://registry.terraform.io/providers/rancher/rke/latest/docs/resources/cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bastion_host"></a> [bastion\_host](#input\_bastion\_host) | Bastion host configuration to access the RKE nodes | <pre>object({<br>    address      = string<br>    user         = string<br>    ssh_key      = string<br>    ssh_key_path = string<br>  })</pre> | `null` | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | Specify the cloud provider name | `string` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name for the RKE cluster | `string` | `"rke-demo"` | no |
| <a name="input_cluster_yaml"></a> [cluster\_yaml](#input\_cluster\_yaml) | cluster.yaml configuration file to apply to the cluster | `string` | `null` | no |
| <a name="input_create_kubeconfig_file"></a> [create\_kubeconfig\_file](#input\_create\_kubeconfig\_file) | Boolean flag to generate a kubeconfig file (mostly used for dev only) | `bool` | `true` | no |
| <a name="input_dependency"></a> [dependency](#input\_dependency) | An optional variable to add a dependency from another resource (not used) | `any` | `null` | no |
| <a name="input_ingress_http_port"></a> [ingress\_http\_port](#input\_ingress\_http\_port) | Specify the http port number to use with Ingress | `number` | `80` | no |
| <a name="input_ingress_https_port"></a> [ingress\_https\_port](#input\_ingress\_https\_port) | Specify the https port number to use with Ingress | `number` | `443` | no |
| <a name="input_ingress_network_mode"></a> [ingress\_network\_mode](#input\_ingress\_network\_mode) | Specify the network mode to use with Ingress | `string` | `"hostPort"` | no |
| <a name="input_ingress_provider"></a> [ingress\_provider](#input\_ingress\_provider) | Ingress controller provider. nginx (default), and none are supported (string) | `string` | `"nginx"` | no |
| <a name="input_kube_config_filename"></a> [kube\_config\_filename](#input\_kube\_config\_filename) | Filename to write the kube config | `string` | `null` | no |
| <a name="input_kube_config_path"></a> [kube\_config\_path](#input\_kube\_config\_path) | The path to write the kubeconfig for the RKE cluster | `string` | `null` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version to use for the RKE cluster | `string` | `null` | no |
| <a name="input_node_internal_ip"></a> [node\_internal\_ip](#input\_node\_internal\_ip) | Internal IP address for single node RKE cluster | `string` | `null` | no |
| <a name="input_node_public_ip"></a> [node\_public\_ip](#input\_node\_public\_ip) | Public IP address for single node RKE cluster | `string` | `null` | no |
| <a name="input_node_username"></a> [node\_username](#input\_node\_username) | Username used for SSH access to the Rancher server cluster node | `string` | `"ubuntu"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix added to names of all resources | `string` | `null` | no |
| <a name="input_private_registry_password"></a> [private\_registry\_password](#input\_private\_registry\_password) | Specify private registry's password | `string` | `null` | no |
| <a name="input_private_registry_url"></a> [private\_registry\_url](#input\_private\_registry\_url) | Specify the private registry where kubernetes images are hosted. Ex: artifactory.company.com/docker | `string` | `null` | no |
| <a name="input_private_registry_username"></a> [private\_registry\_username](#input\_private\_registry\_username) | Specify private registry's username | `string` | `null` | no |
| <a name="input_rancher_nodes"></a> [rancher\_nodes](#input\_rancher\_nodes) | List of compute nodes for Rancher cluster | <pre>list(object({<br>    hostname_override = string<br>    public_ip         = string<br>    private_ip        = string<br>    roles             = list(string)<br>    ssh_key           = string<br>    ssh_key_path      = string<br>  }))</pre> | `null` | no |
| <a name="input_ssh_agent_auth"></a> [ssh\_agent\_auth](#input\_ssh\_agent\_auth) | Enable SSH agent authentication | `bool` | `false` | no |
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | Private key used for SSH access to the Rancher server cluster node(s) | `string` | `null` | no |
| <a name="input_ssh_private_key_path"></a> [ssh\_private\_key\_path](#input\_ssh\_private\_key\_path) | Path to private key used for SSH access to the Rancher server cluster node(s) | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_credentials"></a> [credentials](#output\_credentials) | n/a |
| <a name="output_dependency"></a> [dependency](#output\_dependency) | n/a |
| <a name="output_kube_config_yaml"></a> [kube\_config\_yaml](#output\_kube\_config\_yaml) | n/a |
| <a name="output_rke_kubeconfig_filename"></a> [rke\_kubeconfig\_filename](#output\_rke\_kubeconfig\_filename) | Kubeconfig file location |
