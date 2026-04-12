# Longhorn Module

Deploys [Longhorn](https://longhorn.io) distributed block storage via Helm.

## Usage

```hcl
module "longhorn" {
  source = "../../modules/addons/longhorn"

  kubeconfig_file = "/path/to/kubeconfig.yaml"
}
```

### With custom replica count

```hcl
module "longhorn" {
  source = "../../modules/addons/longhorn"

  kubeconfig_file                = "/path/to/kubeconfig.yaml"
  longhorn_default_replica_count = 2
  longhorn_version               = "1.11.1"
}
```

### Airgap installation

```hcl
module "longhorn" {
  source = "../../modules/addons/longhorn"

  kubeconfig_file         = "/path/to/kubeconfig.yaml"
  airgap                  = true
  system_default_registry = "registry.example.com"
  longhorn_helm_repository = "https://registry.example.com/charts"
}
```

### Ordering after Rancher install

```hcl
module "longhorn" {
  source = "../../modules/addons/longhorn"

  kubeconfig_file = local_file.kube_config_yaml.filename
  dependency      = module.rancher_install.rancher_hostname
}
```

## Notes

- Longhorn requires `open-iscsi` installed on all cluster nodes
- Set `longhorn_default_replica_count = 1` for single-node clusters
- `docs.md` is auto-generated — do not edit manually
