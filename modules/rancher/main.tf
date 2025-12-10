locals {
  rancher_airgap_helm_values = var.airgap ? [
    "rancherImage: ${var.default_registry}/rancher/rancher",
    "systemDefaultRegistry: ${var.default_registry}",
    "useBundledSystemChart: true"
  ] : []
  cert_manager_airgap_helm_values = var.airgap ? [
    "image.repository: ${var.default_registry}/quay.io/jetstack/cert-manager-controller",
    "webhook.image.repository: ${var.default_registry}/quay.io/jetstack/cert-manager-webhook",
    "cainjector.image.repository: ${var.default_registry}/quay.io/jetstack/cert-manager-cainjector",
    "startupapicheck.image.repository: ${var.default_registry}/quay.io/jetstack/cert-manager-ctl"
  ] : []
  cert_manager_default_helm_values = [
    "startupapicheck.timeout: 10m",
    "installCRDs: true"
  ]
  rancher_default_helm_values = [
    "antiAffinity: ${var.rancher_replicas == 1 ? "preferred" : var.rancher_antiaffinity}",
    "ingress.tls.source: ${var.tls_source}",
    "hostname: ${var.rancher_hostname}",
    "bootstrapPassword: ${var.rancher_bootstrap_password == null ? "" : var.rancher_bootstrap_password}",
    "replicas: ${var.rancher_replicas}",
    "global.cattle.psp.enabled: false",
    "postDelete.ignoreTimeoutError: true"
  ]
  rancher_private_ca_values = var.tls_source == "secret" && var.cacerts_path != null ? [
    "privateCA: true"
  ] : []
  rancher_registry_pull_secret = var.registry_username != null ? [
    "imagePullSecrets[0].name: rancher-pull-secret"
  ] : []
  rancher_helm_values      = distinct(flatten([var.rancher_additional_helm_values, local.rancher_airgap_helm_values, local.rancher_registry_pull_secret, local.rancher_private_ca_values, local.rancher_default_helm_values]))
  cert_manager_helm_values = distinct(flatten([local.cert_manager_default_helm_values, local.cert_manager_airgap_helm_values]))
}

resource "kubernetes_secret_v1" "tls_rancher_ingress" {
  depends_on = [var.dependency]
  count      = var.tls_source == "secret" ? 1 : 0
  metadata {
    name      = "tls-rancher-ingress"
    namespace = helm_release.rancher.namespace
  }

  data = {
    "tls.crt" = file(var.tls_crt_path)
    "tls.key" = file(var.tls_key_path)
  }
  type = "kubernetes.io/tls"

  lifecycle {
    ignore_changes = [metadata]
  }
}

resource "kubernetes_secret_v1" "tls_ca" {
  depends_on = [var.dependency]
  count      = var.tls_source == "secret" && var.cacerts_path != null ? 1 : 0
  metadata {
    name      = "tls-ca"
    namespace = helm_release.rancher.namespace
  }

  data = {
    "cacerts.pem" = file(var.cacerts_path)
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}

resource "kubernetes_secret_v1" "image_pull_secret" {
  depends_on = [var.dependency]
  count      = var.registry_username != null ? 1 : 0
  metadata {
    name      = "rancher-pull-secret"
    namespace = helm_release.rancher.namespace
  }

  type = "Opaque"
  data = {
    "username" = var.registry_username
    "password" = var.registry_password
  }

  lifecycle {
    ignore_changes = [metadata]
  }
}

resource "helm_release" "cert_manager" {
  depends_on          = [var.dependency]
  count               = var.tls_source == "rancher" || var.tls_source == "letsEncrypt" || var.cert_manager_enable ? 1 : 0
  name                = "cert-manager"
  chart               = "cert-manager"
  create_namespace    = true
  namespace           = var.cert_manager_namespace
  repository          = var.cert_manager_helm_repository != null ? var.cert_manager_helm_repository : "https://charts.jetstack.io"
  repository_username = var.cert_manager_helm_repository_username != null ? var.cert_manager_helm_repository_username : null
  repository_password = var.cert_manager_helm_repository_password != null ? var.cert_manager_helm_repository_password : null
  version             = var.cert_manager_version
  wait                = false
  atomic              = var.cert_manager_helm_atomic
  upgrade_install     = var.cert_manager_helm_upgrade_install

  set = [
    for v in local.cert_manager_helm_values : {
      name  = split(":", v)[0]
      value = trimspace(replace(v, "${split(":", v)[0]}:", ""))
      type  = trimspace(replace(v, "${split(":", v)[0]}:", "")) == "true" || trimspace(replace(v, "${split(":", v)[0]}:", "")) == "false" ? "string" : null
    }
  ]
}

resource "helm_release" "rancher" {
  depends_on          = [helm_release.cert_manager]
  name                = "rancher"
  chart               = "rancher"
  create_namespace    = true
  namespace           = var.rancher_namespace
  repository          = var.rancher_helm_repository != null ? var.rancher_helm_repository : "https://releases.rancher.com/server-charts/stable"
  repository_username = var.rancher_helm_repository_username != null ? var.rancher_helm_repository_username : null
  repository_password = var.rancher_helm_repository_password != null ? var.rancher_helm_repository_password : null
  version             = var.rancher_version
  timeout             = var.helm_timeout
  wait                = true
  atomic              = var.rancher_helm_atomic
  upgrade_install     = var.rancher_helm_upgrade_install

  set = [
    for v in local.rancher_helm_values : {
      name  = split(":", v)[0]
      value = trimspace(replace(v, "${split(":", v)[0]}:", ""))
    }
  ]
}

resource "null_resource" "wait_for_rancher" {
  depends_on = [helm_release.rancher]
  count      = var.bootstrap_rancher ? 1 : 0
  provisioner "local-exec" {
    command     = <<-EOF
    count=0
    while [ "$${count}" -lt 5 ]; do
      resp=$(curl -k -s -o /dev/null -w "%%{http_code}" https://$${RANCHER_HOSTNAME}/ping)
      echo "Waiting for https://$${RANCHER_HOSTNAME}/ping - response: $${resp}"
      if [ "$${resp}" = "200" ]; then
        ((count++))
      fi
      sleep 2
    done
    EOF
    interpreter = ["/bin/bash", "-c"]
    environment = {
      RANCHER_HOSTNAME = var.rancher_hostname
    }
  }
}

resource "rancher2_bootstrap" "admin" {
  depends_on       = [null_resource.wait_for_rancher[0]]
  count            = var.bootstrap_rancher && var.rancher_password != null ? 1 : 0
  initial_password = var.rancher_bootstrap_password
  password         = var.rancher_password
}

locals {
  bootstrap_message = var.bootstrap_rancher && var.rancher_password != null ? "Rancher will be bootstraped with the password provided" : "Rancher will be installed with a bootstrap password, access the Rancher dashboard to bootstrap and set a password"
}

resource "null_resource" "bootstrap_message" {
  provisioner "local-exec" {
    command = "echo '${local.bootstrap_message}'"
  }
}
