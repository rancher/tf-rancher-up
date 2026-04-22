locals {
  rancher_backup_defaults = {
    persistence = {
      enabled      = var.rancher_backup_storage_backend == "pvc"
      storageClass = var.rancher_backup_pvc_storage_class
      size         = var.rancher_backup_pvc_size
    }
    s3 = {
      enabled                   = var.rancher_backup_storage_backend == "s3"
      bucketName                = var.rancher_backup_s3_bucket
      region                    = var.rancher_backup_s3_region
      endpoint                  = var.rancher_backup_s3_endpoint
      folder                    = var.rancher_backup_s3_folder
      endpointCA                = var.rancher_backup_s3_endpoint_ca
      insecureTLSSkipVerify     = var.rancher_backup_s3_insecure_tls_skip_verify
      credentialSecretName      = var.rancher_backup_s3_credential_secret_name
      credentialSecretNamespace = var.rancher_backup_namespace
    }
  }
}

# rancher-backup chart (v7+) ships CRDs in a separate chart that must be
# installed first. Install it here so callers don't need to manage it.
resource "helm_release" "rancher_backup_operator_crd" {
  depends_on          = [var.dependency]
  name                = "rancher-backup-operator-crd"
  chart               = "rancher-backup-crd"
  create_namespace    = true
  namespace           = var.rancher_backup_namespace
  repository          = var.rancher_backup_helm_repository != null ? var.rancher_backup_helm_repository : "https://charts.rancher.io"
  repository_username = var.rancher_backup_helm_repository_username
  repository_password = var.rancher_backup_helm_repository_password
  version             = var.rancher_backup_version
  wait                = true
  atomic              = var.rancher_backup_helm_atomic
  upgrade_install     = var.rancher_backup_helm_upgrade_install
  timeout             = var.rancher_backup_helm_timeout
}

resource "helm_release" "rancher_backup_operator" {
  depends_on          = [var.dependency, helm_release.rancher_backup_operator_crd]
  name                = "rancher-backup-operator"
  chart               = "rancher-backup"
  create_namespace    = true
  namespace           = var.rancher_backup_namespace
  repository          = var.rancher_backup_helm_repository != null ? var.rancher_backup_helm_repository : "https://charts.rancher.io"
  repository_username = var.rancher_backup_helm_repository_username
  repository_password = var.rancher_backup_helm_repository_password
  version             = var.rancher_backup_version
  wait                = true
  atomic              = var.rancher_backup_helm_atomic
  upgrade_install     = var.rancher_backup_helm_upgrade_install
  timeout             = var.rancher_backup_helm_timeout

  values = compact([
    yamlencode(local.rancher_backup_defaults),
  ])

  set = [
    for v in var.rancher_backup_additional_helm_values : {
      name  = split(":", v)[0]
      value = trimspace(replace(v, "${split(":", v)[0]}:", ""))
    }
  ]
}

# Create a scheduled Backup CR when the user provides a cron schedule.
# NOTE: This resource requires the operator CRD to be present at plan time.
# Use the two-stage apply pattern: deploy the operator first, then set
# rancher_backup_schedule on a subsequent apply.
resource "kubernetes_manifest" "rancher_backup_schedule" {
  count = var.rancher_backup_schedule != null ? 1 : 0

  depends_on = [helm_release.rancher_backup_operator]

  manifest = {
    apiVersion = "resources.cattle.io/v1"
    kind       = "Backup"
    metadata = {
      name = "scheduled-backup"
    }
    spec = {
      resourceSetName = var.rancher_backup_resource_set_name
      schedule        = var.rancher_backup_schedule
      retentionCount  = var.rancher_backup_retention_count
    }
  }
}
