module "aks" {
  source = "../../../../modules/distribution/aks"

  azure_subscription_id            = var.azure_subscription_id
  azure_subscription_tenant_id     = var.azure_subscription_tenant_id
  azure_service_principal_appid    = var.azure_service_principal_appid
  azure_service_principal_password = var.azure_service_principal_password

  prefix               = var.prefix
  azure_region         = var.azure_region
  node_count           = var.node_count
  vm_size              = var.vm_size
  kube_config_filename = var.kube_config_filename
}

provider "helm" {
  kubernetes {
    config_path = module.aks.kubeconfig_file_location
  }
}

resource "helm_release" "ingress-nginx" {
  depends_on       = [module.aks.dependency]
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  create_namespace = true
  namespace        = "ingress-nginx"
  timeout          = 600

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }
  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
  }
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path"
    value = "/healthz"
  }
}

provider "kubernetes" {
  config_path = module.aks.kubeconfig_file_location
}

data "kubernetes_service" "ingress-nginx-controller-svc" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = helm_release.ingress-nginx.namespace
  }
}

locals {
  rancher_hostname = join(".", ["rancher", data.kubernetes_service.ingress-nginx-controller-svc.status.0.load_balancer.0.ingress[0].ip, "sslip.io"])
}

module "rancher_install" {
  source                     = "../../../../modules/rancher"
  kubeconfig_file            = module.aks.kubeconfig_file_location
  rancher_hostname           = local.rancher_hostname
  rancher_replicas           = min(var.rancher_replicas, var.node_count)
  rancher_bootstrap_password = var.rancher_bootstrap_password
  rancher_version            = var.rancher_version
  wait                       = var.wait
  rancher_additional_helm_values = [
    "ingress.ingressClassName: nginx",
  ]
}
