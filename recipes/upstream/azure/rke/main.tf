locals {
  local_ssh_private_key_path = var.ssh_private_key_path == null ? "${path.cwd}/${var.prefix}-ssh_private_key.pem" : var.ssh_private_key_path
  local_ssh_public_key_path  = var.ssh_public_key_path == null ? "${path.cwd}/${var.prefix}-ssh_public_key.pem" : var.ssh_public_key_path
  startup_script             = var.os_type == "sles" ? var.startup_script : "#!/bin/bash\nexport DEBIAN_FRONTEND=noninteractive ; curl -sSL https://releases.rancher.com/install-docker/20.10.sh | sh - ; sudo usermod -aG docker ubuntu ; newgrp docker ; sudo sysctl -w net.bridge.bridge-nf-call-iptables=1 ; sleep 180"
  ssh_username               = var.os_type
  kc_path                    = var.kube_config_path != null ? var.kube_config_path : path.cwd
  kc_file                    = var.kube_config_filename != null ? basename(var.kube_config_filename) : "${var.prefix}_kube_config.yml"
}


module "azure-virtual-machine-upstream-cluster" {
  source               = "../../../../modules/infra/azure/virtual-machine"
  prefix               = var.prefix
  create_rg            = var.create_rg
  region               = var.region
  create_ssh_key_pair  = var.create_ssh_key_pair
  ssh_private_key_path = local.local_ssh_private_key_path
  ssh_public_key_path  = local.local_ssh_public_key_path
  create_vnet          = var.create_vnet
  create_subnet        = var.create_subnet
  create_firewall      = var.create_firewall
  instance_count       = var.instance_count
  instance_disk_size   = var.instance_disk_size
  disk_type            = var.disk_type
  instance_type        = var.instance_type
  os_type              = var.os_type
  spot_instance        = var.spot_instance
  startup_script       = local.startup_script
}

module "rke" {
  source               = "../../../../modules/distribution/rke"
  prefix               = var.prefix
  ssh_private_key_path = local.local_ssh_private_key_path
  kube_config_path     = local.kc_path
  kube_config_filename = local.kc_file
  node_username        = local.ssh_username
  kubernetes_version   = var.kubernetes_version

  rancher_nodes = [for instance_ips in module.azure-virtual-machine-upstream-cluster.instance_ips :
    {
      public_ip         = instance_ips.public_ip,
      private_ip        = instance_ips.private_ip,
      roles             = ["etcd", "controlplane", "worker"],
      ssh_key_path      = local.local_ssh_private_key_path,
      ssh_key           = null,
      hostname_override = null
    }
  ]
}

module "rancher_install" {
  source                           = "../../../../modules/rancher"
  dependency                       = module.rke.dependency
  kubeconfig_file                  = module.rke.rke_kubeconfig_filename
  rancher_hostname                 = join(".", [var.rancher_hostname, module.azure-virtual-machine-upstream-cluster.instances_public_ip[0], "sslip.io"])
  rancher_replicas                 = var.instance_count
  rancher_bootstrap_password       = var.rancher_bootstrap_password
  rancher_password                 = var.rancher_password
  rancher_version                  = var.rancher_version
  rancher_helm_repository          = var.rancher_helm_repository
  rancher_helm_repository_username = var.rancher_helm_repository_username
  rancher_helm_repository_password = var.rancher_helm_repository_password
}