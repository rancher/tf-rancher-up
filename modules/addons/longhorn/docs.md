## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.10.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.23.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.10.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.longhorn](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_airgap"></a> [airgap](#input\_airgap) | If set, configure Longhorn to pull images from system\_default\_registry instead of Docker Hub | `bool` | `false` | no |
| <a name="input_dependency"></a> [dependency](#input\_dependency) | An optional variable to add a dependency from another resource (not used directly) | `any` | `null` | no |
| <a name="input_kubeconfig_file"></a> [kubeconfig\_file](#input\_kubeconfig\_file) | Path to the kubeconfig file to use for the installation | `string` | n/a | yes |
| <a name="input_longhorn_additional_helm_values"></a> [longhorn\_additional\_helm\_values](#input\_longhorn\_additional\_helm\_values) | Helm options to provide to the Longhorn helm chart in key:value format | `list(string)` | `[]` | no |
| <a name="input_longhorn_default_replica_count"></a> [longhorn\_default\_replica\_count](#input\_longhorn\_default\_replica\_count) | Default number of replicas for Longhorn volumes | `number` | `3` | no |
| <a name="input_longhorn_default_storage_class"></a> [longhorn\_default\_storage\_class](#input\_longhorn\_default\_storage\_class) | Whether to set Longhorn as the default storage class for the cluster | `bool` | `true` | no |
| <a name="input_longhorn_helm_atomic"></a> [longhorn\_helm\_atomic](#input\_longhorn\_helm\_atomic) | If set, installation process purges chart on fail; the wait flag will be set automatically if atomic is used | `bool` | `false` | no |
| <a name="input_longhorn_helm_repository"></a> [longhorn\_helm\_repository](#input\_longhorn\_helm\_repository) | Helm repository URL for Longhorn (null defaults to https://charts.longhorn.io) | `string` | `null` | no |
| <a name="input_longhorn_helm_repository_password"></a> [longhorn\_helm\_repository\_password](#input\_longhorn\_helm\_repository\_password) | Password for the Longhorn helm repository | `string` | `null` | no |
| <a name="input_longhorn_helm_repository_username"></a> [longhorn\_helm\_repository\_username](#input\_longhorn\_helm\_repository\_username) | Username for the Longhorn helm repository | `string` | `null` | no |
| <a name="input_longhorn_helm_timeout"></a> [longhorn\_helm\_timeout](#input\_longhorn\_helm\_timeout) | Specify the timeout value in seconds for helm operation(s) | `number` | `600` | no |
| <a name="input_longhorn_helm_upgrade_install"></a> [longhorn\_helm\_upgrade\_install](#input\_longhorn\_helm\_upgrade\_install) | If set, will run helm upgrade --install | `bool` | `true` | no |
| <a name="input_longhorn_namespace"></a> [longhorn\_namespace](#input\_longhorn\_namespace) | Namespace to install Longhorn into | `string` | `"longhorn-system"` | no |
| <a name="input_longhorn_version"></a> [longhorn\_version](#input\_longhorn\_version) | Version of the Longhorn helm chart to install | `string` | `"1.11.1"` | no |
| <a name="input_system_default_registry"></a> [system\_default\_registry](#input\_system\_default\_registry) | Private container image registry to use when airgap is enabled | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_longhorn_default_storage_class_name"></a> [longhorn\_default\_storage\_class\_name](#output\_longhorn\_default\_storage\_class\_name) | Name of the Longhorn storage class (for use as a reference in downstream modules) |
| <a name="output_longhorn_namespace"></a> [longhorn\_namespace](#output\_longhorn\_namespace) | Namespace where Longhorn is installed |
