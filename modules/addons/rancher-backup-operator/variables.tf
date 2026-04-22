variable "kubeconfig_file" {
  description = "Path to the kubeconfig file to use for the installation"
  type        = string
}

variable "rancher_backup_namespace" {
  description = "Namespace to install the Rancher Backup Operator into"
  default     = "cattle-resources-system"
  type        = string
}

variable "rancher_backup_version" {
  description = "Version of the Rancher Backup Operator helm chart to install (null installs the latest available)"
  default     = null
  type        = string
}

variable "rancher_backup_helm_repository" {
  description = "Helm repository URL for the Rancher Backup Operator (null defaults to https://charts.rancher.io)"
  default     = null
  type        = string
}

variable "rancher_backup_helm_repository_username" {
  description = "Username for the Rancher Backup Operator helm repository"
  default     = null
  type        = string
}

variable "rancher_backup_helm_repository_password" {
  description = "Password for the Rancher Backup Operator helm repository"
  default     = null
  type        = string
  sensitive   = true
}

variable "rancher_backup_helm_atomic" {
  description = "If set, installation process purges chart on fail; the wait flag will be set automatically if atomic is used"
  default     = false
  type        = bool
}

variable "rancher_backup_helm_upgrade_install" {
  description = "If set, will run helm upgrade --install"
  default     = true
  type        = bool
}

variable "rancher_backup_helm_timeout" {
  description = "Specify the timeout value in seconds for helm operation(s)"
  default     = 600
  type        = number
}

variable "rancher_backup_storage_backend" {
  description = "Storage backend to use for backups: 'pvc' for a PersistentVolumeClaim or 's3' for an S3-compatible object store"
  default     = "pvc"
  type        = string

  validation {
    condition     = var.rancher_backup_storage_backend == "pvc" || var.rancher_backup_storage_backend == "s3"
    error_message = "rancher_backup_storage_backend must be 'pvc' or 's3'."
  }
}

variable "rancher_backup_pvc_storage_class" {
  description = "Storage class to use for the backup PVC (null uses the cluster default storage class)"
  default     = null
  type        = string
}

variable "rancher_backup_pvc_size" {
  description = "Size of the PVC to create for storing backups"
  default     = "10Gi"
  type        = string
}

variable "rancher_backup_s3_bucket" {
  description = "S3 bucket name for backup storage (required when rancher_backup_storage_backend is 's3')"
  default     = null
  type        = string
}

variable "rancher_backup_s3_region" {
  description = "AWS region for the S3 bucket (required when rancher_backup_storage_backend is 's3')"
  default     = null
  type        = string
}

variable "rancher_backup_s3_endpoint" {
  description = "S3-compatible endpoint URL for non-AWS providers such as Minio"
  default     = null
  type        = string
}

variable "rancher_backup_s3_folder" {
  description = "Optional key prefix (folder) within the S3 bucket where backups are stored"
  default     = null
  type        = string
}

variable "rancher_backup_s3_endpoint_ca" {
  description = "PEM-encoded CA certificate for verifying a custom S3/Minio TLS endpoint"
  default     = null
  type        = string
  sensitive   = true
}

variable "rancher_backup_s3_insecure_tls_skip_verify" {
  description = "Skip TLS certificate verification for the S3 endpoint (use only for dev/self-signed certs)"
  default     = false
  type        = bool
}

variable "rancher_backup_s3_credential_secret_name" {
  description = "Name of the Kubernetes Secret containing S3 access credentials (required when rancher_backup_storage_backend is 's3')"
  default     = null
  type        = string
}

variable "rancher_backup_schedule" {
  description = "Cron expression for automatic backups (e.g. '0 0 * * *' for daily at midnight). null disables scheduled backups."
  default     = null
  type        = string
}

variable "rancher_backup_retention_count" {
  description = "Number of backup files to retain when using a schedule (older backups are deleted)"
  default     = 10
  type        = number
}

variable "rancher_backup_resource_set_name" {
  description = "Name of the ResourceSet that defines which Kubernetes resources are included in backups"
  default     = "rancher-resource-set"
  type        = string
}

variable "rancher_backup_additional_helm_values" {
  description = "Helm options to provide to the Rancher Backup Operator helm chart in key:value format"
  default     = []
  type        = list(string)
}

variable "dependency" {
  description = "An optional variable to add a dependency from another resource (not used directly)"
  default     = null
}
