# vSphere Provider Configuration
provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = var.vsphere_allow_unverified_ssl
}

# LOCALS - Cloud-Init Composition and Logic
locals {
  kc_path = var.kube_config_path != null ? var.kube_config_path : path.cwd
  kc_file = "${local.kc_path}/${var.prefix}_kube_config.yml"

  # SSH Key Logic
  ssh_key_name         = "${var.prefix}-ssh-key"
  ssh_private_key_path = var.create_ssh_key_pair ? "${path.cwd}/${local.ssh_key_name}" : var.ssh_private_key_path
  ssh_public_key_path  = var.create_ssh_key_pair ? "${path.cwd}/${local.ssh_key_name}.pub" : var.ssh_public_key_path

  # Content for usage
  ssh_public_key_content = var.create_ssh_key_pair ? tls_private_key.ssh_key[0].public_key_openssh : file(var.ssh_public_key_path)

  # Docker Install Script (RKE requirement)
  docker_install_script = <<-EOT
    #!/bin/bash
    # Install Docker
    curl https://releases.rancher.com/install-docker/24.0.sh | sh
    usermod -aG docker ${var.vm_username}
  EOT
}

# SSH KEY GENERATION
resource "tls_private_key" "ssh_key" {
  count     = var.create_ssh_key_pair ? 1 : 0
  algorithm = "ED25519"
}

resource "local_file" "private_key" {
  count           = var.create_ssh_key_pair ? 1 : 0
  filename        = local.ssh_private_key_path
  content         = tls_private_key.ssh_key[0].private_key_openssh
  file_permission = "0600"
}

resource "local_file" "public_key" {
  count           = var.create_ssh_key_pair ? 1 : 0
  filename        = local.ssh_public_key_path
  content         = tls_private_key.ssh_key[0].public_key_openssh
  file_permission = "0644"
}

# INFRASTRUCTURE - VM PROVISIONING
module "vms" {
  source               = "../../../../modules/infra/vmware"
  prefix               = var.prefix
  instance_count       = var.instance_count
  vm_cpus              = var.vm_cpus
  vm_memory            = var.vm_memory
  vm_disk              = var.vm_disk
  vm_username          = var.vm_username
  ssh_public_key       = local.ssh_public_key_content
  ssh_private_key_path = local.ssh_private_key_path
  create_ssh_key_pair  = false

  # vSphere configuration
  vsphere_server               = var.vsphere_server
  vsphere_user                 = var.vsphere_user
  vsphere_password             = var.vsphere_password
  vsphere_datacenter           = var.vsphere_datacenter
  vsphere_datastore            = var.vsphere_datastore
  vsphere_cluster              = var.vsphere_cluster
  vsphere_host                 = var.vsphere_host
  vsphere_resource_pool        = var.vsphere_resource_pool
  vsphere_folder               = var.vsphere_folder
  vsphere_network              = var.vsphere_network
  vsphere_virtual_machine      = var.vsphere_virtual_machine
  vsphere_allow_unverified_ssl = var.vsphere_allow_unverified_ssl

  # Merged cloud-init
  user_data = templatefile("${path.module}/cloud-init-multipart.yaml.tpl", {
    vm_username            = var.vm_username
    ssh_public_key_content = local.ssh_public_key_content
    install_script         = local.docker_install_script
  })
}

# RKE - CLUSTER PROVISIONING
module "rke" {
  source = "../../../../modules/distribution/rke"

  # Use all VM IDs to ensure RKE waits for all nodes to be provisioned
  dependency = join(",", module.vms.vm_ids)

  prefix               = var.prefix
  node_username        = var.vm_username
  ssh_private_key_path = local.ssh_private_key_path
  kubernetes_version   = var.kubernetes_version
  kube_config_path     = local.kc_path
  kube_config_filename = basename(local.kc_file)

  rancher_nodes = [
    for i in range(var.instance_count) : {
      hostname_override = "${var.prefix}-${i + 1}"
      public_ip         = module.vms.instances_private_ip[i]
      private_ip        = module.vms.instances_private_ip[i]
      roles             = ["controlplane", "etcd", "worker"]
      ssh_key           = var.create_ssh_key_pair ? tls_private_key.ssh_key[0].private_key_openssh : null
      ssh_key_path      = var.create_ssh_key_pair ? null : local.ssh_private_key_path
    }
  ]
}

# RANCHER INSTALLATION 
module "rancher_install" {
  source = "../../../../modules/rancher"

  # Use rke_kubeconfig_filename to ensure the file is created and the path is tracked as an apply-time value
  dependency                            = module.rke.rke_kubeconfig_filename
  kubeconfig_file                       = module.rke.rke_kubeconfig_filename
  rancher_hostname                      = join(".", ["rancher", module.vms.instances_private_ip[0], "sslip.io"])
  rancher_replicas                      = min(var.rancher_replicas, var.instance_count)
  rancher_bootstrap_password            = var.rancher_bootstrap_password
  rancher_password                      = var.rancher_password
  rancher_version                       = var.rancher_version
  rancher_helm_repository               = var.rancher_helm_repository
  rancher_helm_repository_username      = var.rancher_helm_repository_username
  rancher_helm_repository_password      = var.rancher_helm_repository_password
  cert_manager_helm_repository          = var.cert_manager_helm_repository
  cert_manager_helm_repository_username = var.cert_manager_helm_repository_username
  cert_manager_helm_repository_password = var.cert_manager_helm_repository_password
  wait                                  = var.wait
  helm_timeout                          = var.helm_timeout
}