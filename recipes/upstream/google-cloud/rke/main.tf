locals {
  local_ssh_private_key_path = var.ssh_private_key_path == null ? "${path.cwd}/${var.prefix}-ssh_private_key.pem" : var.ssh_private_key_path
  local_ssh_public_key_path  = var.ssh_public_key_path == null ? "${path.cwd}/${var.prefix}-ssh_public_key.pem" : var.ssh_public_key_path
  ssh_username               = var.os_type
  startup_script             = var.os_type == "sles" ? var.startup_script : "export DEBIAN_FRONTEND=noninteractive ; curl -sSL https://releases.rancher.com/install-docker/20.10.sh | sh - ; sudo usermod -aG docker ubuntu ; newgrp docker ; sudo sysctl -w net.bridge.bridge-nf-call-iptables=1 ; sleep 180"
  kc_path                    = var.kube_config_path != null ? var.kube_config_path : path.cwd
  kc_file                    = var.kube_config_filename != null ? "${local.kc_path}/${var.kube_config_filename}" : "${local.kc_path}/${var.prefix}_kube_config.yml"
}

module "google-compute-engine-upstream-cluster" {
  source               = "../../../../modules/infra/google-cloud/compute-engine"
  prefix               = var.prefix
  project_id           = var.project_id
  region               = var.region
  create_ssh_key_pair  = var.create_ssh_key_pair
  ssh_private_key_path = local.local_ssh_private_key_path
  ssh_public_key_path  = local.local_ssh_public_key_path
  create_vpc           = var.create_vpc
  vpc                  = var.vpc
  subnet               = var.subnet
  create_firewall      = var.create_firewall
  instance_count       = var.instance_count
  instance_disk_size   = var.instance_disk_size
  disk_type            = var.disk_type
  instance_type        = var.instance_type
  os_type              = var.os_type
  startup_script       = local.startup_script
}

resource "null_resource" "wait-docker-startup" {
  depends_on = [module.google-compute-engine-upstream-cluster.instances_public_ip]

  provisioner "local-exec" {
    command = "sleep ${var.waiting_time}"
  }
}

module "rke" {
  source               = "../../../../modules/distribution/rke"
  prefix               = var.prefix
  dependency           = [null_resource.wait-docker-startup]
  ssh_private_key_path = local.local_ssh_private_key_path
  node_username        = local.ssh_username
  ingress_provider     = var.ingress_provider

  rancher_nodes = [for instance_ips in module.google-compute-engine-upstream-cluster.instance_ips :
    {
      public_ip         = instance_ips.public_ip,
      private_ip        = instance_ips.public_ip,
      roles             = ["etcd", "controlplane", "worker"],
      ssh_key_path      = local.local_ssh_private_key_path,
      ssh_key           = null,
      hostname_override = null
    }
  ]
}

resource "null_resource" "wait-k8s-services-startup" {
  depends_on = [module.rke]

  provisioner "local-exec" {
    command = "sleep ${var.waiting_time}"
  }
}

locals {
  rancher_hostname = var.rancher_hostname != null ? join(".", ["${var.rancher_hostname}", module.google-compute-engine-upstream-cluster.instances_public_ip[0], "sslip.io"]) : join(".", ["rancher", module.google-compute-engine-upstream-cluster.instances_public_ip[0], "sslip.io"])

}

module "rancher_install" {
  source                     = "../../../../modules/rancher"
  dependency                 = [module.google-compute-engine-upstream-cluster, null_resource.wait-k8s-services-startup]
  kubeconfig_file            = local.kc_file
  rancher_hostname           = local.rancher_hostname
  rancher_bootstrap_password = var.rancher_bootstrap_password
  rancher_password           = var.rancher_password
  bootstrap_rancher          = var.bootstrap_rancher
  rancher_version            = var.rancher_version
  rancher_additional_helm_values = [
    "replicas: ${var.instance_count}"
  ]
}
