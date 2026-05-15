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
| [rancher2_cluster.cluster](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the imported cluster | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The ID of the created cluster |
| <a name="output_command"></a> [command](#output\_command) | The manifest URL for the cluster registration |
| <a name="output_insecure_command"></a> [insecure\_command](#output\_insecure\_command) | The manifest URL for the cluster registration |
| <a name="output_manifest_url"></a> [manifest\_url](#output\_manifest\_url) | The manifest URL for the cluster registration |
