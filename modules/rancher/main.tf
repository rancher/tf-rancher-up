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
    "bootstrapPassword: ${var.rancher_bootstrap_password}",
    "replicas: ${var.rancher_replicas}"
  ]
  rancher_private_ca_values = var.tls_source == "secret" && var.cacerts_path != null ? [
    "privateCA: true"
  ] : []
  rancher_registry_pull_secret = var.registry_username != null ? [
    "imagePullSecrets[0].name: rancher-pull-secret"
  ] : []
  rancher_helm_values = distinct(flatten([var.rancher_additional_helm_values, local.rancher_airgap_helm_values, local.rancher_registry_pull_secret, local.rancher_private_ca_values, local.rancher_default_helm_values]))
  cert_manager_helm_values = distinct(flatten([local.cert_manager_default_helm_values, local.cert_manager_airgap_helm_values]))
}

resource "kubernetes_secret" "tls_rancher_ingress" {
  count = var.tls_source == "secret" ? 1 : 0
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

resource "kubernetes_secret" "tls_ca" {
  count = var.tls_source == "secret" && var.cacerts_path != null ? 1 : 0
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

resource "kubernetes_secret" "image_pull_secret" {
  count = var.registry_username != null ? 1 : 0
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
  count               = var.tls_source == "rancher" || var.tls_source == "letsEncrypt" || var.cert_manager_enable ? 1 : 0
  name                = "cert-manager"
  repository          = var.helm_repository != null ? var.helm_repository : "https://charts.jetstack.io"
  chart               = "cert-manager"
  namespace           = var.cert_manager_namespace
  version             = var.cert_manager_version
  repository_username = var.helm_username != null ? var.helm_username : null
  repository_password = var.helm_password != null ? var.helm_password : null
  wait                = true
  create_namespace    = true

  dynamic "set" {
    for_each = local.cert_manager_helm_values
    content {
      name  = split(":", set.value)[0]
      value = trimspace(replace(set.value, "${split(":", set.value)[0]}:", ""))
      type  = trimspace(replace(set.value, "${split(":", set.value)[0]}:", "")) == "true" || trimspace(replace(set.value, "${split(":", set.value)[0]}:", "")) == "false" ? "string" : null
    }
  }
}

resource "helm_release" "rancher" {
  depends_on          = [helm_release.cert_manager]
  name                = "rancher"
  repository          = var.helm_repository != null ? var.helm_repository : "https://releases.rancher.com/server-charts/stable"
  chart               = "rancher"
  namespace           = "cattle-system"
  version             = var.rancher_version
  repository_username = var.helm_username != null ? var.helm_username : null
  repository_password = var.helm_password != null ? var.helm_password : null
  wait                = true
  create_namespace    = true

  dynamic "set" {
    for_each = local.rancher_helm_values
    content {
      name  = split(":", set.value)[0]
      value = trimspace(replace(set.value, "${split(":", set.value)[0]}:", ""))
      type  = trimspace(replace(set.value, "${split(":", set.value)[0]}:", "")) == "true" || trimspace(replace(set.value, "${split(":", set.value)[0]}:", "")) == "false" ? "string" : null
    }
  }
}
