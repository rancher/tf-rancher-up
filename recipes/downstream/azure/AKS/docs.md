## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_rancher2"></a> [rancher2](#requirement\_rancher2) | ~> 7.3.2 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_downstream_aks"></a> [downstream\_aks](#module\_downstream\_aks) | ../../../../modules/downstream/azure/AKS/ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_client_id"></a> [client\_id](#input\_client\_id) | Azure client ID | `string` | `null` | no |
| <a name="input_client_secret"></a> [client\_secret](#input\_client\_secret) | Azure client secret | `string` | `null` | no |
| <a name="input_cloud_credential_id"></a> [cloud\_credential\_id](#input\_cloud\_credential\_id) | Rancher cloud credential to use, instead of AZURE client id/secret (ex: cattle-global-data:cc-xxx) | `string` | `null` | no |
| <a name="input_cluster_description"></a> [cluster\_description](#input\_cluster\_description) | Description of the AKS cluster | `string` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the AKS cluster | `string` | `null` | no |
| <a name="input_dns_prefix"></a> [dns\_prefix](#input\_dns\_prefix) | DNS prefix for the cluster | `string` | `null` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version | `string` | `"1.33.2"` | no |
| <a name="input_network_plugin"></a> [network\_plugin](#input\_network\_plugin) | Network plugin to use | `string` | `"kubenet"` | no |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | List of node pools configuration | <pre>list(object({<br/>    availability_zones   = list(string)<br/>    name                 = string<br/>    count                = number<br/>    orchestrator_version = string<br/>    os_disk_size_gb      = number<br/>    vm_size              = string<br/>  }))</pre> | n/a | yes |
| <a name="input_rancher_insecure"></a> [rancher\_insecure](#input\_rancher\_insecure) | Skip TLS verification for Rancher API | `bool` | `true` | no |
| <a name="input_rancher_token"></a> [rancher\_token](#input\_rancher\_token) | Rancher API token | `string` | `null` | no |
| <a name="input_rancher_url"></a> [rancher\_url](#input\_rancher\_url) | The Rancher server URL | `string` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | Azure resource group name | `string` | n/a | yes |
| <a name="input_resource_location"></a> [resource\_location](#input\_resource\_location) | Azure region used for all resources | `string` | `"eastus"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription ID | `string` | `null` | no |

## Outputs

No outputs.
