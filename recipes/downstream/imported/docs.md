## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_imported_cluster"></a> [imported\_cluster](#module\_imported\_cluster) | ../../../modules/downstream/imported | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the imported cluster | `string` | `"imported-cluster"` | no |
| <a name="input_rancher_insecure"></a> [rancher\_insecure](#input\_rancher\_insecure) | n/a | `bool` | `true` | no |
| <a name="input_rancher_token"></a> [rancher\_token](#input\_rancher\_token) | Rancher Token Key | `string` | n/a | yes |
| <a name="input_rancher_url"></a> [rancher\_url](#input\_rancher\_url) | Rancher API URL | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_command"></a> [command](#output\_command) | The kubectl apply command for cluster import |
| <a name="output_insecure_command"></a> [insecure\_command](#output\_insecure\_command) | The insecure kubectl apply command for cluster import |
