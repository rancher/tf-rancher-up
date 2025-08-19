## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_rancher2"></a> [rancher2](#requirement\_rancher2) | ~> 7.3.2 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_downstream_eks"></a> [downstream\_eks](#module\_downstream\_eks) | ../../../../modules/downstream/aws/EKS/ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | AWS access key | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region used for all resources | `string` | `"us-east-1"` | no |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | AWS secret key | `string` | `null` | no |
| <a name="input_cloud_credential_id"></a> [cloud\_credential\_id](#input\_cloud\_credential\_id) | Rancher cloud credential to use, instead of AWS access/secret key (ex: cattle-global-data:cc-xxx) | `string` | `null` | no |
| <a name="input_cluster_description"></a> [cluster\_description](#input\_cluster\_description) | EKS cluster description | `string` | `"Terraform managed EKS cluster"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the Rancher EKS cluster | `string` | n/a | yes |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version for the EKS cluster | `string` | `null` | no |
| <a name="input_logging_types"></a> [logging\_types](#input\_logging\_types) | EKS control plane logging types | `list(string)` | <pre>[<br/>  "audit",<br/>  "api"<br/>]</pre> | no |
| <a name="input_node_groups"></a> [node\_groups](#input\_node\_groups) | Configuration for EKS node groups | <pre>list(object({<br/>    name          = string<br/>    instance_type = string<br/>    desired_size  = number<br/>    max_size      = number<br/>    min_size      = number<br/>  }))</pre> | n/a | yes |
| <a name="input_private_access"></a> [private\_access](#input\_private\_access) | Enable private API server endpoint | `bool` | `true` | no |
| <a name="input_public_access"></a> [public\_access](#input\_public\_access) | Enable public API server endpoint | `bool` | `true` | no |
| <a name="input_rancher_insecure"></a> [rancher\_insecure](#input\_rancher\_insecure) | Allow insecure connections to Rancher | `bool` | `true` | no |
| <a name="input_rancher_token"></a> [rancher\_token](#input\_rancher\_token) | Rancher API token | `string` | `null` | no |
| <a name="input_rancher_url"></a> [rancher\_url](#input\_rancher\_url) | The Rancher server URL | `string` | `null` | no |

## Outputs

No outputs.
