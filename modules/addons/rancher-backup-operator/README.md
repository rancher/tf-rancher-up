# Rancher Backup Operator Module

Deploys the [Rancher Backup Operator](https://github.com/rancher/backup-restore-operator) via Helm with support for PVC or S3/Minio storage backends.

## Usage

### PVC backend (default)

```hcl
module "rancher_backup" {
  source = "../../modules/addons/rancher-backup-operator"

  kubeconfig_file = "/path/to/kubeconfig.yaml"
}
```

### S3 backend

```hcl
module "rancher_backup" {
  source = "../../modules/addons/rancher-backup-operator"

  kubeconfig_file                          = "/path/to/kubeconfig.yaml"
  rancher_backup_storage_backend           = "s3"
  rancher_backup_s3_bucket                 = "my-rancher-backups"
  rancher_backup_s3_region                 = "us-east-1"
  rancher_backup_s3_credential_secret_name = "s3-credentials"
}
```

The S3 credential Secret must be created separately and contain `accessKey` and `secretKey` data fields.

### Minio backend

```hcl
module "rancher_backup" {
  source = "../../modules/addons/rancher-backup-operator"

  kubeconfig_file                          = "/path/to/kubeconfig.yaml"
  rancher_backup_storage_backend           = "s3"
  rancher_backup_s3_bucket                 = "rancher-backups"
  rancher_backup_s3_region                 = "us-east-1"
  rancher_backup_s3_endpoint               = "https://minio.example.com"
  rancher_backup_s3_credential_secret_name = "minio-credentials"
}
```

### Ordering after Rancher install

```hcl
module "rancher_backup" {
  source = "../../modules/addons/rancher-backup-operator"

  kubeconfig_file = local_file.kube_config_yaml.filename
  dependency      = module.rancher_install.rancher_hostname
}
```

## Notes

- This module automatically installs the `rancher-backup-crd` chart before the operator chart. Chart version 7+ ships CRDs separately; the module handles this transparently.
- The S3 credential Secret must be created separately and contain `accessKey` and `secretKey` data fields.
- `docs.md` is auto-generated — do not edit manually
