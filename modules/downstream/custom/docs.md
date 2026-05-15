## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_rancher2"></a> [rancher2](#requirement\_rancher2) | >= 8.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_rancher2"></a> [rancher2](#provider\_rancher2) | >= 8.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [rancher2_cluster_v2.cluster](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster_v2) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the custom cluster | `string` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version for the custom cluster | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The ID of the created cluster |
| <a name="output_insecure_node_command"></a> [insecure\_node\_command](#output\_insecure\_node\_command) | The insecure node command to register nodes to the cluster |
| <a name="output_node_command"></a> [node\_command](#output\_node\_command) | The node command to register nodes to the cluster |
