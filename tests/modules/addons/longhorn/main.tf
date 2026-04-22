module "longhorn_defaults" {
  source          = "../../../../modules/addons/longhorn"
  kubeconfig_file = "./test-kubeconfig.yaml"
}

module "longhorn_single_replica" {
  source = "../../../../modules/addons/longhorn"

  kubeconfig_file                = "./test-kubeconfig.yaml"
  longhorn_default_replica_count = 1
  longhorn_default_storage_class = false
}

module "longhorn_airgap" {
  source = "../../../../modules/addons/longhorn"

  kubeconfig_file         = "./test-kubeconfig.yaml"
  airgap                  = true
  system_default_registry = "registry.example.com"
}
