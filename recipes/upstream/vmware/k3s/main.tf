# LOCALS - Cloud-Init Composition

locals {
  kc_path = var.kube_config_path != null ? var.kube_config_path : path.cwd
  kc_file = "${local.kc_path}/${var.prefix}_kubeconfig.yaml"

  # SSH Key Logic
  ssh_key_name         = "k3s-key"
  ssh_private_key_path = var.create_ssh_key_pair ? "${path.cwd}/${local.ssh_key_name}" : var.ssh_private_key_path
  ssh_public_key_path  = var.create_ssh_key_pair ? "${path.cwd}/${local.ssh_key_name}.pub" : var.ssh_public_key_path

  # Content for usage
  ssh_public_key_content = var.create_ssh_key_pair ? tls_private_key.ssh_key[0].public_key_openssh : file(var.ssh_public_key_path)

  # ingress mapping for rancher logic
  k3s_ingress = var.k3s_ingress

  ingress_class_map = {
    "nginx"         = "nginx"
    "ingress-nginx" = "nginx"
    "traefik"       = "traefik"
  }
  rancher_ingress_class = lookup(local.ingress_class_map, var.k3s_ingress, var.k3s_ingress)
}

# K3S  - FIRST SERVER (Token + Config Generation)

module "k3s_first" {
  source      = "../../../../modules/distribution/k3s"
  k3s_token   = var.k3s_token
  k3s_version = var.k3s_version
  k3s_config  = var.k3s_config
  k3s_channel = var.k3s_channel
}

# CLOUD-INIT COMPOSITION - FIRST SERVER

locals {
  # First server network wait script
  network_wait_script = <<-EOT
    #!/bin/bash
    # Wait for network
    timeout 60 bash -c 'until ping -c1 8.8.8.8 &>/dev/null; do sleep 2; done'
  EOT
}

# INFRASTRUCTURE - FIRST SERVER

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

module "k3s_first_server" {
  source               = "../../../../modules/infra/vmware"
  prefix               = "${var.prefix}-cp"
  instance_count       = 1
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
    hostname               = "${var.prefix}-cp-1"
    vm_username            = var.vm_username
    ssh_public_key_content = local.ssh_public_key_content
    wait_script            = local.network_wait_script
    k3s_script             = module.k3s_first.k3s_server_user_data
  })
}

# K3S - ADDITIONAL SERVERS

module "k3s_additional" {
  source          = "../../../../modules/distribution/k3s"
  k3s_token       = module.k3s_first.k3s_token
  k3s_version     = var.k3s_version
  k3s_config      = var.k3s_config
  k3s_channel     = var.k3s_channel
  first_server_ip = module.k3s_first_server.instances_private_ip[0]
}

# CLOUD-INIT COMPOSITION - ADDITIONAL SERVERS

locals {
  additional_wait_script = <<-EOT
    #!/bin/bash
    # Wait for network
    timeout 60 bash -c 'until ping -c1 8.8.8.8 &>/dev/null; do sleep 2; done'
    # Wait for first server to be ready on 6443 (API and K3s node join)
    timeout 300 bash -c 'until nc -zv ${module.k3s_first_server.instances_private_ip[0]} 6443 &>/dev/null; do sleep 5; done'
  EOT
}

# INFRASTRUCTURE - ADDITIONAL SERVERS

module "k3s_additional_servers" {
  count                = var.instance_count > 1 ? var.instance_count - 1 : 0
  source               = "../../../../modules/infra/vmware"
  prefix               = "${var.prefix}-cp"
  instance_count       = 1
  start_index          = count.index + 2
  vm_cpus              = var.vm_cpus
  vm_memory            = var.vm_memory
  vm_disk              = var.vm_disk
  vm_username          = var.vm_username
  ssh_public_key       = local.ssh_public_key_content
  ssh_private_key_path = local.ssh_private_key_path
  create_ssh_key_pair  = false

  # vSphere configuration (same as first server)
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

  # Merged cloud-init for additional servers
  user_data = templatefile("${path.module}/cloud-init-multipart.yaml.tpl", {
    hostname               = "${var.prefix}-cp-${count.index + 2}"
    vm_username            = var.vm_username
    ssh_public_key_content = local.ssh_public_key_content
    wait_script            = local.additional_wait_script
    k3s_script             = module.k3s_additional.k3s_server_user_data
  })

  # Ensure first server is deployed first
  depends_on = [module.k3s_first_server]
}

# KUBECONFIG RETRIEVAL

resource "null_resource" "wait_for_k3s" {
  depends_on = [module.k3s_first_server]

  triggers = {
    server_id = module.k3s_first_server.instances_private_ip[0]
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for K3s to be ready...'",
      "timeout 600 bash -c 'until test -f /etc/rancher/k3s/k3s.yaml; do sleep 5; done'",
      "timeout 300 bash -c 'until systemctl is-active k3s; do sleep 3; done'",
      "echo 'K3s server is ready!'"
    ]

    connection {
      type        = "ssh"
      host        = module.k3s_first_server.instances_private_ip[0]
      user        = var.vm_username
      private_key = file(pathexpand(module.k3s_first_server.ssh_key_path))
    }
  }
}

resource "null_resource" "wait_for_cluster_ready" {
  depends_on = [null_resource.wait_for_k3s, module.k3s_additional_servers]

  triggers = {
    instance_count = var.instance_count
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for all ${var.instance_count} nodes to be Ready...'",
      "timeout 900 bash -c 'until [ $(sudo kubectl --kubeconfig /etc/rancher/k3s/k3s.yaml get nodes --no-headers | grep -c \" Ready\") -eq ${var.instance_count} ]; do sleep 10; echo \"Waiting for nodes... Current count: $(sudo kubectl --kubeconfig /etc/rancher/k3s/k3s.yaml get nodes --no-headers | grep -c \" Ready\")\"; done'",
      "echo 'All nodes are Ready!'"
    ]

    connection {
      type        = "ssh"
      host        = module.k3s_first_server.instances_private_ip[0]
      user        = var.vm_username
      private_key = file(pathexpand(module.k3s_first_server.ssh_key_path))
    }
  }
}

resource "null_resource" "retrieve_kubeconfig" {
  depends_on = [null_resource.wait_for_cluster_ready]

  triggers = {
    server_id = module.k3s_first_server.instances_private_ip[0]
  }

  provisioner "local-exec" {
    command = <<-EOT
      ssh -o StrictHostKeyChecking=no \
          -i ${pathexpand(module.k3s_first_server.ssh_key_path)} \
          ${var.vm_username}@${module.k3s_first_server.instances_private_ip[0]} \
          "sudo cat /etc/rancher/k3s/k3s.yaml" | \
      sed 's/127.0.0.1/${module.k3s_first_server.instances_private_ip[0]}/g' | \
      sed 's/certificate-authority-data:.*/insecure-skip-tls-verify: true/g' > ${local.kc_file}
      chmod 600 ${local.kc_file}
    EOT
  }
}

# RANCHER INSTALLATION 
locals {
  rancher_hostname = join(".", ["rancher", module.k3s_first_server.instances_private_ip[0], "sslip.io"])
}

module "rancher_install" {
  source = "../../../../modules/rancher"

  dependency = null_resource.retrieve_kubeconfig.id

  kubeconfig_file                       = local.kc_file
  rancher_hostname                      = local.rancher_hostname
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

  rancher_additional_helm_values = [
    "replicas: ${min(var.rancher_replicas, var.instance_count)}",
    "ingress.ingressClassName: ${local.rancher_ingress_class}"
  ]
}
