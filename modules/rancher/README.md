# Terraform | Rancher Install

Terraform module to install Rancher using helm to complete an HA installation.

Documentation can be found [here](./docs.md).

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
