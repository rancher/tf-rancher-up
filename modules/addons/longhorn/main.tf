locals {
  longhorn_defaults = {
    defaultSettings = {
      defaultReplicaCount = var.longhorn_default_replica_count
    }
    persistence = {
      defaultClass             = var.longhorn_default_storage_class
      defaultClassReplicaCount = var.longhorn_default_replica_count
    }
  }

  longhorn_airgap = {
    global = {
      cattle = {
        systemDefaultRegistry = var.system_default_registry
      }
    }
  }
}

resource "helm_release" "longhorn" {
  depends_on          = [var.dependency]
  name                = "longhorn"
  chart               = "longhorn"
  create_namespace    = true
  namespace           = var.longhorn_namespace
  repository          = var.longhorn_helm_repository != null ? var.longhorn_helm_repository : "https://charts.longhorn.io"
  repository_username = var.longhorn_helm_repository_username
  repository_password = var.longhorn_helm_repository_password
  version             = var.longhorn_version
  wait                = true
  atomic              = var.longhorn_helm_atomic
  upgrade_install     = var.longhorn_helm_upgrade_install
  timeout             = var.longhorn_helm_timeout

  values = compact([
    yamlencode(local.longhorn_defaults),
    var.airgap ? yamlencode(local.longhorn_airgap) : "",
  ])

  set = [
    for v in var.longhorn_additional_helm_values : {
      name  = split(":", v)[0]
      value = trimspace(replace(v, "${split(":", v)[0]}:", ""))
    }
  ]
}
