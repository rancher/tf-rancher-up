## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.10.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.23.0 |
| <a name="requirement_rancher2"></a> [rancher2](#requirement\_rancher2) | >= 3.1.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.10.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.23.0 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_rancher2"></a> [rancher2](#provider\_rancher2) | >= 3.1.1 |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.rancher](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_secret.image_pull_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.tls_ca](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [kubernetes_secret.tls_rancher_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) | resource |
| [null_resource.bootstrap_message](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.wait_for_rancher](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [rancher2_bootstrap.admin](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/bootstrap) | resource |
| [time_sleep.sleep-for-ingress-webhook](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_airgap"></a> [airgap](#input\_airgap) | Enable airgap options for the Rancher environment, requires default\_registry to be set | `bool` | `false` | no |
| <a name="input_bootstrap_rancher"></a> [bootstrap\_rancher](#input\_bootstrap\_rancher) | Bootstrap the Rancher installation | `bool` | `true` | no |
| <a name="input_cacerts_path"></a> [cacerts\_path](#input\_cacerts\_path) | Private CA certificate to use for Rancher UI/API connectivity | `string` | `null` | no |
| <a name="input_cert_manager_enable"></a> [cert\_manager\_enable](#input\_cert\_manager\_enable) | Install cert-manager even if not needed for Rancher, useful if migrating to certificates | `string` | `false` | no |
| <a name="input_cert_manager_namespace"></a> [cert\_manager\_namespace](#input\_cert\_manager\_namespace) | Namespace to install cert-manager | `string` | `"cert-manager"` | no |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | Version of cert-manager to install | `string` | `"v1.11.0"` | no |
| <a name="input_default_registry"></a> [default\_registry](#input\_default\_registry) | Default container image registry to pull images in the format of registry.domain.com:port (systemDefaultRegistry helm value) | `string` | `null` | no |
| <a name="input_dependency"></a> [dependency](#input\_dependency) | An optional variable to add a dependency from another resource (not used) | `any` | `null` | no |
| <a name="input_helm_password"></a> [helm\_password](#input\_helm\_password) | Private helm repository password | `string` | `null` | no |
| <a name="input_helm_repository"></a> [helm\_repository](#input\_helm\_repository) | Helm repository for Rancher and cert-manager charts | `string` | `null` | no |
| <a name="input_helm_timeout"></a> [helm\_timeout](#input\_helm\_timeout) | Specify the timeout value in seconds for helm operation(s) | `number` | `600` | no |
| <a name="input_helm_username"></a> [helm\_username](#input\_helm\_username) | Private helm repository username | `string` | `null` | no |
| <a name="input_kubeconfig_file"></a> [kubeconfig\_file](#input\_kubeconfig\_file) | The kubeconfig to use to interact with the cluster | `string` | `"~/.kube/config"` | no |
| <a name="input_rancher_additional_helm_values"></a> [rancher\_additional\_helm\_values](#input\_rancher\_additional\_helm\_values) | Helm options to provide to the Rancher helm chart | `list(string)` | `[]` | no |
| <a name="input_rancher_antiaffinity"></a> [rancher\_antiaffinity](#input\_rancher\_antiaffinity) | Value for antiAffinity when installing the Rancher helm chart (required/preferred) | `string` | `"required"` | no |
| <a name="input_rancher_bootstrap_password"></a> [rancher\_bootstrap\_password](#input\_rancher\_bootstrap\_password) | Password to use for bootstrapping Rancher (min 12 characters) | `string` | `"initial-admin-password"` | no |
| <a name="input_rancher_hostname"></a> [rancher\_hostname](#input\_rancher\_hostname) | Value for hostname when installing the Rancher helm chart | `string` | n/a | yes |
| <a name="input_rancher_namespace"></a> [rancher\_namespace](#input\_rancher\_namespace) | The Rancher release will be deployed to this namespace | `string` | `"cattle-system"` | no |
| <a name="input_rancher_password"></a> [rancher\_password](#input\_rancher\_password) | Password to use for Rancher (min 12 characters) | `string` | `null` | no |
| <a name="input_rancher_replicas"></a> [rancher\_replicas](#input\_rancher\_replicas) | Value for replicas when installing the Rancher helm chart | `number` | `3` | no |
| <a name="input_rancher_version"></a> [rancher\_version](#input\_rancher\_version) | Rancher version to install | `string` | `null` | no |
| <a name="input_registry_password"></a> [registry\_password](#input\_registry\_password) | Private container image registry password | `string` | `null` | no |
| <a name="input_registry_username"></a> [registry\_username](#input\_registry\_username) | Private container image registry username | `string` | `null` | no |
| <a name="input_tls_crt_path"></a> [tls\_crt\_path](#input\_tls\_crt\_path) | TLS certificate to use for Rancher UI/API connectivity | `string` | `null` | no |
| <a name="input_tls_key_path"></a> [tls\_key\_path](#input\_tls\_key\_path) | TLS key to use for Rancher UI/API connectivity | `string` | `null` | no |
| <a name="input_tls_source"></a> [tls\_source](#input\_tls\_source) | Value for ingress.tls.source when installing the Rancher helm chart | `string` | `"rancher"` | no |
| <a name="input_wait"></a> [wait](#input\_wait) | An optional wait before installing the Rancher helm chart (seconds) | `any` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rancher_admin_token"></a> [rancher\_admin\_token](#output\_rancher\_admin\_token) | Rancher API token for the admin user |
| <a name="output_rancher_bootstrap_password"></a> [rancher\_bootstrap\_password](#output\_rancher\_bootstrap\_password) | Password for the Rancher admin account |
| <a name="output_rancher_hostname"></a> [rancher\_hostname](#output\_rancher\_hostname) | Value for hostname when installing the Rancher helm chart |
