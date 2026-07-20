## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_rancher2"></a> [rancher2](#requirement\_rancher2) | >= 8.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_custom_cluster"></a> [custom\_cluster](#module\_custom\_cluster) | ../../../modules/downstream/custom | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the custom cluster | `string` | `"custom-cluster"` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version for the custom cluster | `string` | n/a | yes |
| <a name="input_rancher_insecure"></a> [rancher\_insecure](#input\_rancher\_insecure) | n/a | `bool` | `true` | no |
| <a name="input_rancher_token"></a> [rancher\_token](#input\_rancher\_token) | Rancher API token | `string` | n/a | yes |
| <a name="input_rancher_url"></a> [rancher\_url](#input\_rancher\_url) | The Rancher server URL | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_insecure_node_command"></a> [insecure\_node\_command](#output\_insecure\_node\_command) | The insecure node command to register nodes to the cluster |
| <a name="output_node_command"></a> [node\_command](#output\_node\_command) | The secure node command to register nodes to the cluster |
