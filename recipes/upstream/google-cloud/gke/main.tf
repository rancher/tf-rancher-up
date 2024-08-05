module "google-kubernetes-engine" {
  source               = "../../../../modules/distribution/gke"
  prefix               = var.prefix
  project_id           = var.project_id
  region               = var.region
  kube_config_filename = var.kube_config_filename
  #  vpc        = var.vpc
  #  subnet     = var.subnet
  #  cluster_version    = var.cluster_version
  #  instance_count = var.instance_count
  #  instance_disk_size = var.instance_disk_size
  #  disk_type          = var.disk_type
  #  image_type         = var.image_type
  #  instance_type      = var.instance_type
}

resource "helm_release" "ingress-nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  create_namespace = true
  namespace        = "ingress-nginx"

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }
}

data "kubernetes_service" "ingress-nginx-controller-svc" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = resource.helm_release.ingress-nginx.namespace
  }
}

locals {
  rancher_hostname = var.rancher_hostname != null ? join(".", [var.rancher_hostname, data.kubernetes_service.ingress-nginx-controller-svc.status.0.load_balancer.0.ingress[0].ip, "sslip.io"]) : join(".", ["rancher", data.kubernetes_service.ingress-nginx-controller-svc.status.0.load_balancer.0.ingress[0].ip, "sslip.io"])
}

module "rancher_install" {
  source                     = "../../../../modules/rancher"
  dependency                 = [data.kubernetes_service.ingress-nginx-controller-svc]
  kubeconfig_file            = "${path.cwd}/${var.prefix}_kube_config.yml"
  rancher_hostname           = local.rancher_hostname
  rancher_bootstrap_password = var.rancher_bootstrap_password
  rancher_password           = var.rancher_password
  rancher_version            = var.rancher_version
  rancher_additional_helm_values = [
    "replicas: 3",
    "ingress.ingressClassName: nginx",
    "service.type: NodePort"
  ]
}