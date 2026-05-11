module "rancher_backup_pvc_defaults" {
  source          = "../../../../modules/addons/rancher-backup-operator"
  kubeconfig_file = "./test-kubeconfig.yaml"
}

module "rancher_backup_pvc_custom" {
  source = "../../../../modules/addons/rancher-backup-operator"

  kubeconfig_file                  = "./test-kubeconfig.yaml"
  rancher_backup_pvc_storage_class = "longhorn"
  rancher_backup_pvc_size          = "20Gi"
}

module "rancher_backup_s3" {
  source = "../../../../modules/addons/rancher-backup-operator"

  kubeconfig_file                          = "./test-kubeconfig.yaml"
  rancher_backup_storage_backend           = "s3"
  rancher_backup_s3_bucket                 = "my-rancher-backups"
  rancher_backup_s3_region                 = "us-east-1"
  rancher_backup_s3_credential_secret_name = "s3-credentials"
}
