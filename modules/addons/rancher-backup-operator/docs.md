## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.10.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.23.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.10.1 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.23.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.rancher_backup_operator](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.rancher_backup_operator_crd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_manifest.rancher_backup_schedule](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dependency"></a> [dependency](#input\_dependency) | An optional variable to add a dependency from another resource (not used directly) | `any` | `null` | no |
| <a name="input_kubeconfig_file"></a> [kubeconfig\_file](#input\_kubeconfig\_file) | Path to the kubeconfig file to use for the installation | `string` | n/a | yes |
| <a name="input_rancher_backup_additional_helm_values"></a> [rancher\_backup\_additional\_helm\_values](#input\_rancher\_backup\_additional\_helm\_values) | Helm options to provide to the Rancher Backup Operator helm chart in key:value format | `list(string)` | `[]` | no |
| <a name="input_rancher_backup_helm_atomic"></a> [rancher\_backup\_helm\_atomic](#input\_rancher\_backup\_helm\_atomic) | If set, installation process purges chart on fail; the wait flag will be set automatically if atomic is used | `bool` | `false` | no |
| <a name="input_rancher_backup_helm_repository"></a> [rancher\_backup\_helm\_repository](#input\_rancher\_backup\_helm\_repository) | Helm repository URL for the Rancher Backup Operator (null defaults to https://charts.rancher.io) | `string` | `null` | no |
| <a name="input_rancher_backup_helm_repository_password"></a> [rancher\_backup\_helm\_repository\_password](#input\_rancher\_backup\_helm\_repository\_password) | Password for the Rancher Backup Operator helm repository | `string` | `null` | no |
| <a name="input_rancher_backup_helm_repository_username"></a> [rancher\_backup\_helm\_repository\_username](#input\_rancher\_backup\_helm\_repository\_username) | Username for the Rancher Backup Operator helm repository | `string` | `null` | no |
| <a name="input_rancher_backup_helm_timeout"></a> [rancher\_backup\_helm\_timeout](#input\_rancher\_backup\_helm\_timeout) | Specify the timeout value in seconds for helm operation(s) | `number` | `600` | no |
| <a name="input_rancher_backup_helm_upgrade_install"></a> [rancher\_backup\_helm\_upgrade\_install](#input\_rancher\_backup\_helm\_upgrade\_install) | If set, will run helm upgrade --install | `bool` | `true` | no |
| <a name="input_rancher_backup_namespace"></a> [rancher\_backup\_namespace](#input\_rancher\_backup\_namespace) | Namespace to install the Rancher Backup Operator into | `string` | `"cattle-resources-system"` | no |
| <a name="input_rancher_backup_pvc_size"></a> [rancher\_backup\_pvc\_size](#input\_rancher\_backup\_pvc\_size) | Size of the PVC to create for storing backups | `string` | `"10Gi"` | no |
| <a name="input_rancher_backup_pvc_storage_class"></a> [rancher\_backup\_pvc\_storage\_class](#input\_rancher\_backup\_pvc\_storage\_class) | Storage class to use for the backup PVC (null uses the cluster default storage class) | `string` | `null` | no |
| <a name="input_rancher_backup_resource_set_name"></a> [rancher\_backup\_resource\_set\_name](#input\_rancher\_backup\_resource\_set\_name) | Name of the ResourceSet that defines which Kubernetes resources are included in backups | `string` | `"rancher-resource-set"` | no |
| <a name="input_rancher_backup_retention_count"></a> [rancher\_backup\_retention\_count](#input\_rancher\_backup\_retention\_count) | Number of backup files to retain when using a schedule (older backups are deleted) | `number` | `10` | no |
| <a name="input_rancher_backup_s3_bucket"></a> [rancher\_backup\_s3\_bucket](#input\_rancher\_backup\_s3\_bucket) | S3 bucket name for backup storage (required when rancher\_backup\_storage\_backend is 's3') | `string` | `null` | no |
| <a name="input_rancher_backup_s3_credential_secret_name"></a> [rancher\_backup\_s3\_credential\_secret\_name](#input\_rancher\_backup\_s3\_credential\_secret\_name) | Name of the Kubernetes Secret containing S3 access credentials (required when rancher\_backup\_storage\_backend is 's3') | `string` | `null` | no |
| <a name="input_rancher_backup_s3_endpoint"></a> [rancher\_backup\_s3\_endpoint](#input\_rancher\_backup\_s3\_endpoint) | S3-compatible endpoint URL for non-AWS providers such as Minio | `string` | `null` | no |
| <a name="input_rancher_backup_s3_endpoint_ca"></a> [rancher\_backup\_s3\_endpoint\_ca](#input\_rancher\_backup\_s3\_endpoint\_ca) | PEM-encoded CA certificate for verifying a custom S3/Minio TLS endpoint | `string` | `null` | no |
| <a name="input_rancher_backup_s3_folder"></a> [rancher\_backup\_s3\_folder](#input\_rancher\_backup\_s3\_folder) | Optional key prefix (folder) within the S3 bucket where backups are stored | `string` | `null` | no |
| <a name="input_rancher_backup_s3_insecure_tls_skip_verify"></a> [rancher\_backup\_s3\_insecure\_tls\_skip\_verify](#input\_rancher\_backup\_s3\_insecure\_tls\_skip\_verify) | Skip TLS certificate verification for the S3 endpoint (use only for dev/self-signed certs) | `bool` | `false` | no |
| <a name="input_rancher_backup_s3_region"></a> [rancher\_backup\_s3\_region](#input\_rancher\_backup\_s3\_region) | AWS region for the S3 bucket (required when rancher\_backup\_storage\_backend is 's3') | `string` | `null` | no |
| <a name="input_rancher_backup_schedule"></a> [rancher\_backup\_schedule](#input\_rancher\_backup\_schedule) | Cron expression for automatic backups (e.g. '0 0 * * *' for daily at midnight). null disables scheduled backups. | `string` | `null` | no |
| <a name="input_rancher_backup_storage_backend"></a> [rancher\_backup\_storage\_backend](#input\_rancher\_backup\_storage\_backend) | Storage backend to use for backups: 'pvc' for a PersistentVolumeClaim or 's3' for an S3-compatible object store | `string` | `"pvc"` | no |
| <a name="input_rancher_backup_version"></a> [rancher\_backup\_version](#input\_rancher\_backup\_version) | Version of the Rancher Backup Operator helm chart to install (null installs the latest available) | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rancher_backup_namespace"></a> [rancher\_backup\_namespace](#output\_rancher\_backup\_namespace) | Namespace where the Rancher Backup Operator is installed |
