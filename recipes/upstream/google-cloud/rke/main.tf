module "google-compute-engine-upstream-cluster" {
  source     = "../../../../modules/infra/google-cloud/compute-engine"
  prefix     = var.prefix
  project_id = var.project_id
  region     = var.region
  #  create_ssh_key_pair = var.create_ssh_key_pair
  #  ssh_public_key_path = var.ssh_public_key_path
  #  vpc                 = var.vpc
  #  subnet              = var.subnet
  #  instance_count      = var.instance_count
  #  instance_disk_size  = var.instance_disk_size
  #  disk_type           = var.disk_type
  #  instance_type       = var.instance_type
  #  os_image            = var.os_image
  #  ssh_username        = var.ssh_username
  startup_script = var.startup_script
}

resource "null_resource" "wait-docker-startup" {
  depends_on = [module.google-compute-engine-upstream-cluster.instances_public_ip]
  provisioner "local-exec" {
    command = "sleep 180"
  }
}

locals {
  ssh_private_key_path = var.ssh_private_key_path != null ? var.ssh_private_key_path : "${path.cwd}/${var.prefix}-ssh_private_key.pem"
}

module "rke" {
  source               = "../../../../modules/distribution/rke"
  prefix               = var.prefix
  dependency           = [resource.null_resource.wait-docker-startup]
  ssh_private_key_path = local.ssh_private_key_path
  node_username        = var.ssh_username
  #  kubernetes_version   = var.kubernetes_version
  ingress_provider = var.ingress_provider

  rancher_nodes = [for instance_ips in module.google-compute-engine-upstream-cluster.instance_ips :
    {
      public_ip  = instance_ips.public_ip,
      private_ip = instance_ips.public_ip,
      roles      = ["etcd", "controlplane", "worker"]
    }
  ]
}

resource "helm_release" "ingress-nginx" {
  depends_on       = [module.rke]
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  create_namespace = true
  namespace        = "ingress-nginx"

  set {
    name  = "controller.service.type"
    value = "NodePort"
  }

  set {
    name  = "controller.replicaCount"
    value = "3"
  }
}

data "kubernetes_service" "ingress-nginx-controller-svc" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = resource.helm_release.ingress-nginx.namespace
  }
}

locals {
  rancher_hostname = var.rancher_hostname != null ? join(".", ["${var.rancher_hostname}", module.google-compute-engine-upstream-cluster.instances_public_ip[0], "sslip.io"]) : join(".", ["rancher", module.google-compute-engine-upstream-cluster.instances_public_ip[0], "sslip.io"])
}

module "rancher_install" {
  source                     = "../../../../modules/rancher"
  dependency                 = [data.kubernetes_service.ingress-nginx-controller-svc]
  kubeconfig_file            = "${path.cwd}/${var.prefix}_kube_config.yml"
  rancher_hostname           = local.rancher_hostname
  rancher_bootstrap_password = var.rancher_password
  bootstrap_rancher          = var.bootstrap_rancher
  # rancher_version                = var.rancher_version
  rancher_additional_helm_values = [
    "replicas: 3",
    "ingress.ingressClassName: nginx",
    "service.type: ClusterIP"
  ]
}
