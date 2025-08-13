## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_rancher2"></a> [rancher2](#requirement\_rancher2) | ~> 7.3.2 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_downstream_gke"></a> [downstream\_gke](#module\_downstream\_gke) | ../../../../modules/downstream/gcp/GKE/ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloud_credential_id"></a> [cloud\_credential\_id](#input\_cloud\_credential\_id) | Existing cloud credential ID. If not provided, a new credential will be created | `string` | `null` | no |
| <a name="input_cloud_credential_name"></a> [cloud\_credential\_name](#input\_cloud\_credential\_name) | Name for the cloud credential (only used when creating new credential) | `string` | `"terraform-gcp-credential"` | no |
| <a name="input_cluster_description"></a> [cluster\_description](#input\_cluster\_description) | Description for the GKE cluster | `string` | `"Terraform managed GKE cluster"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the Rancher GKE cluster | `string` | `"ranchergke"` | no |
| <a name="input_gcp_credentials_path"></a> [gcp\_credentials\_path](#input\_gcp\_credentials\_path) | Path to the GCP service account JSON file | `string` | `null` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version for the cluster | `string` | `"1.32.6-gke.1125000"` | no |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | List of node pools configuration | <pre>list(object({<br/>    name                = string<br/>    initial_node_count  = optional(number, 1)<br/>    version             = optional(string, null)<br/>    max_pods_constraint = optional(number, 110)<br/>  }))</pre> | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP Project ID where the cluster will be created | `string` | n/a | yes |
| <a name="input_rancher_insecure"></a> [rancher\_insecure](#input\_rancher\_insecure) | Skip TLS verification for Rancher API | `bool` | `true` | no |
| <a name="input_rancher_token"></a> [rancher\_token](#input\_rancher\_token) | Rancher API token | `string` | `null` | no |
| <a name="input_rancher_url"></a> [rancher\_url](#input\_rancher\_url) | The Rancher server URL | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region or zone for the cluster | `string` | `"us-east1-b"` | no |

## Outputs

No outputs.
