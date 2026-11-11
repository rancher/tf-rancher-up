## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.1.0 |
| <a name="requirement_rancher2"></a> [rancher2](#requirement\_rancher2) | ~> 15.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | >= 2.1.0 |
| <a name="provider_rancher2"></a> [rancher2](#provider\_rancher2) | ~> 15.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [local_sensitive_file.kubeconfig](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file) | resource |
| [rancher2_cloud_credential.do_credential](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cloud_credential) | resource |
| [rancher2_cluster_v2.cluster](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster_v2) | resource |
| [rancher2_machine_config_v2.machine_config](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/machine_config_v2) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backups"></a> [backups](#input\_backups) | Enable backups for droplets | `bool` | `false` | no |
| <a name="input_cloud_credential_id"></a> [cloud\_credential\_id](#input\_cloud\_credential\_id) | Rancher cloud credential to use, instead of a DigitalOcean access token (ex: cattle-global-data:cc-xxx) | `string` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The cluster name | `string` | `"v2-ds"` | no |
| <a name="input_cni_provider"></a> [cni\_provider](#input\_cni\_provider) | CNI provider to use | `string` | `"calico"` | no |
| <a name="input_cp_count"></a> [cp\_count](#input\_cp\_count) | Control plane pool node count | `number` | `1` | no |
| <a name="input_cp_node_pool_name"></a> [cp\_node\_pool\_name](#input\_cp\_node\_pool\_name) | Control plane pool name | `string` | `"cp"` | no |
| <a name="input_custom_user_data"></a> [custom\_user\_data](#input\_custom\_user\_data) | Custom user data passed to the machine driver userdata field for v2 clusters. Rancher interprets the value (content is not appended by tf-rancher-up). Default null. | `string` | `null` | no |
| <a name="input_do_token"></a> [do\_token](#input\_do\_token) | DigitalOcean access token used to create infrastructure | `string` | `null` | no |
| <a name="input_image"></a> [image](#input\_image) | DigitalOcean image slug used for all nodes. Also used as the default for machine pools that do not set one | `string` | `"ubuntu-24-04-x64"` | no |
| <a name="input_ipv6"></a> [ipv6](#input\_ipv6) | Enable IPv6 for droplets | `bool` | `false` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version to use for the RKE2/k3s cluster | `string` | `null` | no |
| <a name="input_machine_pools"></a> [machine\_pools](#input\_machine\_pools) | Optional list of machine pools. When set, replaces the legacy cp\_*/worker\_* pool configuration. Each pool creates its own machine config, allowing per-pool placement and sizing | <pre>list(object({<br/>    name                = string<br/>    roles               = list(string)<br/>    count               = optional(number, 1)<br/>    drain_before_delete = optional(bool, true)<br/>    region              = optional(string, null)<br/>    size                = optional(string, null)<br/>    image               = optional(string, null)<br/>  }))</pre> | `null` | no |
| <a name="input_monitoring"></a> [monitoring](#input\_monitoring) | Enable monitoring for droplets | `bool` | `false` | no |
| <a name="input_private_networking"></a> [private\_networking](#input\_private\_networking) | Enable private networking for droplets | `bool` | `true` | no |
| <a name="input_rancher_insecure"></a> [rancher\_insecure](#input\_rancher\_insecure) | Allow insecure connections to Rancher | `bool` | `true` | no |
| <a name="input_rancher_token"></a> [rancher\_token](#input\_rancher\_token) | Rancher API token | `string` | `null` | no |
| <a name="input_rancher_url"></a> [rancher\_url](#input\_rancher\_url) | The Rancher server URL | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | DigitalOcean region used for all resources | `string` | `"sfo3"` | no |
| <a name="input_rke2_ingress"></a> [rke2\_ingress](#input\_rke2\_ingress) | RKE2 ingress deployed (ingress-nginx or traefik) | `string` | `"traefik"` | no |
| <a name="input_size"></a> [size](#input\_size) | Droplet size used for all nodes. Also used as the default for machine pools that do not set one | `string` | `"s-2vcpu-4gb"` | no |
| <a name="input_ssh_key_contents"></a> [ssh\_key\_contents](#input\_ssh\_key\_contents) | SSH private key contents used to access the nodes | `string` | `null` | no |
| <a name="input_ssh_key_fingerprint"></a> [ssh\_key\_fingerprint](#input\_ssh\_key\_fingerprint) | SSH key fingerprint registered in DigitalOcean | `string` | `null` | no |
| <a name="input_ssh_port"></a> [ssh\_port](#input\_ssh\_port) | SSH port used to access the nodes | `string` | `"22"` | no |
| <a name="input_ssh_user"></a> [ssh\_user](#input\_ssh\_user) | Username used for SSH with sudo access | `string` | `"root"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Comma-separated list of tags to apply to the droplets | `string` | `null` | no |
| <a name="input_worker_count"></a> [worker\_count](#input\_worker\_count) | Worker pool node count | `number` | `1` | no |
| <a name="input_worker_node_pool_name"></a> [worker\_node\_pool\_name](#input\_worker\_node\_pool\_name) | Worker pool name | `string` | `"w"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kubeconfig_file"></a> [kubeconfig\_file](#output\_kubeconfig\_file) | The local path to the generated downstream kubeconfig |
