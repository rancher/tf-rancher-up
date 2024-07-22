locals {
  kc_path = var.kube_config_path != null ? var.kube_config_path : path.cwd
  kc_file = var.kube_config_filename != null ? "${local.kc_path}/${var.kube_config_filename}" : "${local.kc_path}/${var.prefix}_kube_config.yml"
}

module "google_kubernetes_engine" {
  source     = "../../../../modules/distribution/gke"
  prefix     = var.prefix
  project_id = var.project_id
  region     = var.region
  #  vpc                = var.vpc
  #  subnet             = var.subnet
  #  cluster_version    = var.cluster_version
  #  instance_count     = var.instance_count
  #  instance_disk_size = var.instance_disk_size
  #  disk_type          = var.disk_type
  #  image_type         = var.image_type
  #  instance_type      = var.instance_type
}

resource "local_file" "kube_config_yaml" {
  depends_on = [module.google_kubernetes_engine.kubernetes_cluster_node_pool]

  content = templatefile("../../../../modules/distribution/gke/template_kube_config.yml", {
    cluster_name    = module.google_kubernetes_engine.cluster_name,
    endpoint        = module.google_kubernetes_engine.cluster_endpoint,
    cluster_ca      = module.google_kubernetes_engine.cluster_ca_certificate,
    client_cert     = module.google_kubernetes_engine.client_certificate,
    client_cert_key = module.google_kubernetes_engine.client_key
  })
  file_permission = "0600"
  filename        = local.kc_file
}

provider "kubernetes" {
  config_path = local_file.kube_config_yaml.filename
}

provider "helm" {
  kubernetes {
    config_path = local_file.kube_config_yaml.filename
  }
}

resource "null_resource" "first_setup" {
  depends_on = [local_file.kube_config_yaml]

  provisioner "local-exec" {
    command = "sh ${path.cwd}/first_setup.sh"
  }
}

resource "kubernetes_namespace" "ingress_nginx_namespace" {
  depends_on = [null_resource.first_setup]

  metadata {
    name = "ingress-nginx"
  }
}

resource "helm_release" "ingress_nginx" {
  depends_on = [kubernetes_namespace.ingress_nginx_namespace]
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress-nginx"
  timeout    = var.waiting_time

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }
}

resource "null_resource" "wait_ingress_startup" {
  depends_on = [helm_release.ingress_nginx]
  provisioner "local-exec" {
    command = <<EOT
    end=$((SECONDS + ${var.waiting_time}))
    while [ $SECONDS -lt $end ]; do
      if kubectl get service ingress-nginx-controller -n ingress-nginx; then
        echo "Ingress Nginx controller is available"
        exit 0
      else
        echo "Waiting for ingress-nginx-controller to be available..."
      fi
      sleep 10
    done
    echo "Timeout waiting for ingress-nginx-controller"
    exit 1
    EOT
  }
}

data "kubernetes_service" "ingress_nginx_controller_svc" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = resource.helm_release.ingress_nginx.namespace
  }
}

resource "null_resource" "wait_ingress_services_startup" {
  depends_on = [data.kubernetes_service.ingress_nginx_controller_svc]
  provisioner "local-exec" {
    command = "sleep ${var.waiting_time}"
  }
}

locals {
  rancher_hostname = var.rancher_hostname != null ? join(".", ["${var.rancher_hostname}", data.kubernetes_service.ingress_nginx_controller_svc.status.0.load_balancer.0.ingress[0].ip, "sslip.io"]) : join(".", ["rancher", data.kubernetes_service.ingress_nginx_controller_svc.status.0.load_balancer.0.ingress[0].ip, "sslip.io"])
}

module "rancher_install" {
  source                     = "../../../../modules/rancher"
  dependency                 = [null_resource.wait_ingress_services_startup]
  kubeconfig_file            = "${path.cwd}/${var.prefix}_kube_config.yml"
  rancher_hostname           = local.rancher_hostname
  rancher_bootstrap_password = var.rancher_password
  rancher_password           = var.rancher_password
  rancher_version            = var.rancher_version
  rancher_additional_helm_values = [
    "replicas: 3",
    "ingress.ingressClassName: nginx",
    "service.type: NodePort"
  ]
}
