# NOTE: Do not gate config_path on a pre-apply file-existence check
# (e.g. `can(file(...))`). That check runs when the provider config is
# first evaluated, which happens before any resource that creates the
# kubeconfig file (e.g. a null_resource writing it via local-exec) has
# run. On a fresh checkout the file doesn't exist yet, so the check
# would permanently lock config_path to null for the whole apply. The
# providers only read this path lazily when a resource actually needs
# the connection, by which point the file has been created — so it's
# safe, and necessary, to always pass the path unconditionally.
provider "helm" {
  kubernetes = {
    config_path = var.kubeconfig_file
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_file
}

provider "rancher2" {
  api_url   = "https://${var.rancher_hostname}"
  bootstrap = true
  insecure  = true
  timeout   = "240s"
}
