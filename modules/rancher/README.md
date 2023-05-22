# Terraform | Rancher Install

Terraform module to install Rancher using helm to complete an HA installation.

### Usage

Reference the module in a terraform file.

For example, `rancher.tf`:
```hcl
module "rancher_install" {
  source = "git::https://github.com/rancherlabs/tf-rancher-up.git//modules/rancher"

  rancher_hostname = "rancher.example.com"
}
```

```bash
terraform init
terraform apply
```

## Examples

#### Private CA and certificates

```hcl
module "rancher_install" {
  source = "git::https://github.com/rancherlabs/tf-rancher-up.git//modules/rancher"

  rancher_hostname = "rancher.example.com"

  tls_source   = "secret"
  cacerts_path = "certs/ca.pem"
  tls_crt_path = "certs/cert.pem"
  tls_key_path = "certs/key.pem"
}
```

#### Custom kubeconfig location

```hcl
module "rancher_install" {
  source = "git::https://github.com/rancherlabs/tf-rancher-up.git//modules/rancher"

  rancher_hostname = "rancher.example.com"
  kubeconfig_file  = "/path/to/kubeconfig"
}
```

#### Single replica for Rancher, and pin the version

```hcl
module "rancher_install" {
  source = "git::https://github.com/rancherlabs/tf-rancher-up.git//modules/rancher"

  rancher_hostname = "rancher.example.com"
  rancher_replicas  = 1
  rancher_version   = "2.6.2"
}
```

#### Additional values for the Rancher chart

```hcl
module "rancher_install" {
  source = "git::https://github.com/rancherlabs/tf-rancher-up.git//modules/rancher"

  rancher_hostname = "rancher.example.com"
  rancher_additional_helm_values = [
    "bootstrapPassword: secret-string",
    "auditLog.level: 1"
  ]
}
```

#### Air-gap environment (without auth)

```hcl
module "rancher_install" {
  source = "git::https://github.com/rancherlabs/tf-rancher-up.git//modules/rancher"

  rancher_hostname = "rancher.example.com"

  airgap = true
  default_registry = "registry.example.com:5000"
  helm_repository = "https://helm.example.com/rancher-charts/"
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.8.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.16.1 |
| <a name="requirement_rancher2"></a> [rancher2](#requirement\_rancher2) | 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.8.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.16.1 |
| <a name="provider_rancher2"></a> [rancher2](#provider\_rancher2) | 3.0.0 |

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
| [rancher2_bootstrap.admin](https://registry.terraform.io/providers/rancher/rancher2/3.0.0/docs/resources/bootstrap) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_airgap"></a> [airgap](#input\_airgap) | Enable airgap options for the Rancher environment, requires default\_registry to be set | `bool` | `false` | no |
| <a name="input_bootstrap_rancher"></a> [bootstrap\_rancher](#input\_bootstrap\_rancher) | Bootstrap the Rancher installation | `bool` | `true` | no |
| <a name="input_cacerts_path"></a> [cacerts\_path](#input\_cacerts\_path) | Private CA certificate to use for Rancher UI/API connectivity | `string` | `null` | no |
| <a name="input_cert_manager_enable"></a> [cert\_manager\_enable](#input\_cert\_manager\_enable) | Install cert-manager even if not needed for Rancher, useful if migrating to certificates | `string` | `false` | no |
| <a name="input_cert_manager_namespace"></a> [cert\_manager\_namespace](#input\_cert\_manager\_namespace) | Namesapce to install cert-manager | `string` | `"cert-manager"` | no |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | Version of cert-manager to install | `string` | `"v1.5.1"` | no |
| <a name="input_default_registry"></a> [default\_registry](#input\_default\_registry) | Default container image registry to pull images in the format of registry.domain.com:port (systemDefaultRegistry helm value) | `string` | `null` | no |
| <a name="input_helm_password"></a> [helm\_password](#input\_helm\_password) | Private helm repository password | `string` | `null` | no |
| <a name="input_helm_repository"></a> [helm\_repository](#input\_helm\_repository) | Helm repository for Rancher and cert-manager charts | `string` | `null` | no |
| <a name="input_helm_username"></a> [helm\_username](#input\_helm\_username) | Private helm repository username | `string` | `null` | no |
| <a name="input_rancher_additional_helm_values"></a> [rancher\_additional\_helm\_values](#input\_rancher\_additional\_helm\_values) | Helm options to provide to the Rancher helm chart | `list(string)` | `[]` | no |
| <a name="input_rancher_antiaffinity"></a> [rancher\_antiaffinity](#input\_rancher\_antiaffinity) | Value for antiAffinity when installing the Rancher helm chart (required/preferred) | `string` | `"required"` | no |
| <a name="input_rancher_bootstrap_password"></a> [rancher\_bootstrap\_password](#input\_rancher\_bootstrap\_password) | Password to use for bootstrapping Rancher (min 12 characters) | `string` | `"initial-admin-password"` | no |
| <a name="input_rancher_hostname"></a> [rancher\_hostname](#input\_rancher\_hostname) | Value for hostname when installing the Rancher helm chart | `string` | n/a | yes |
| <a name="input_rancher_replicas"></a> [rancher\_replicas](#input\_rancher\_replicas) | Value for replicas when installing the Rancher helm chart | `number` | `3` | no |
| <a name="input_rancher_version"></a> [rancher\_version](#input\_rancher\_version) | Rancher version to install | `string` | `null` | no |
| <a name="input_registry_password"></a> [registry\_password](#input\_registry\_password) | Private container image registry password | `string` | `null` | no |
| <a name="input_registry_username"></a> [registry\_username](#input\_registry\_username) | Private container image registry username | `string` | `null` | no |
| <a name="input_tls_crt_path"></a> [tls\_crt\_path](#input\_tls\_crt\_path) | TLS certificate to use for Rancher UI/API connectivity | `string` | `null` | no |
| <a name="input_tls_key_path"></a> [tls\_key\_path](#input\_tls\_key\_path) | TLS key to use for Rancher UI/API connectivity | `string` | `null` | no |
| <a name="input_tls_source"></a> [tls\_source](#input\_tls\_source) | Value for ingress.tls.source when installing the Rancher helm chart | `string` | `"rancher"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rancher_bootstrap_password"></a> [rancher\_bootstrap\_password](#output\_rancher\_bootstrap\_password) | Password for the Rancher admin account |
| <a name="output_rancher_hostname"></a> [rancher\_hostname](#output\_rancher\_hostname) | Value for hostname when installing the Rancher helm chart |
| <a name="output_rancher_token"></a> [rancher\_token](#output\_rancher\_token) | Rancher API token for the admin user |