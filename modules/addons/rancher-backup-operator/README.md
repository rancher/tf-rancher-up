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
  rancher_backup_s3_folder                 = "my-cluster"
  rancher_backup_s3_insecure_tls_skip_verify = true   # for self-signed certs
  rancher_backup_s3_credential_secret_name = "minio-credentials"
}
```

### With a scheduled backup job

```hcl
module "rancher_backup" {
  source = "../../modules/addons/rancher-backup-operator"

  kubeconfig_file                = "/path/to/kubeconfig.yaml"
  rancher_backup_schedule        = "0 2 * * *"  # daily at 02:00
  rancher_backup_retention_count = 7
}
```

**Important:** `rancher_backup_schedule` creates a `Backup` Custom Resource. The CRD must exist at plan time, which means a two-stage apply is required when provisioning a new cluster:

1. First apply without `rancher_backup_schedule` to install the operator and register the CRDs.
2. Add `rancher_backup_schedule` and apply again — Terraform can now resolve the CRD schema.

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
