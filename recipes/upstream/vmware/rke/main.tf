module "upstream-cluster" {
  source                           = "../../../../modules/infra/vmware"
  ssh_private_key_path             = var.ssh_private_key_path
  vsphere_datacenter               = var.vsphere_datacenter
  vsphere_resource_pool            = var.vsphere_resource_pool
  vsphere_datastore                = var.vsphere_datastore
  vsphere_virtual_machine_template = var.vsphere_virtual_machine_template
  vsphere_network                  = var.vsphere_network
  authorized_keys                  = var.authorized_keys
  prefix                           = var.prefix
  vm_username                      = var.vm_username
  docker_version                   = var.docker_version
  instance_count                   = var.instance_count
  vm_cpus                          = var.vm_cpus
  vm_disk                          = var.vm_disk
  vm_memory                        = var.vm_memory
}

module "rke" {
  source     = "../../../../modules/distribution/rke"
  depends_on = [module.upstream-cluster]

  node_username        = var.vm_username
  ssh_private_key_path = var.ssh_private_key_path

  rancher_nodes = [for instance_ips in module.upstream-cluster.ip_addresses[*] :
    {
      public_ip = instance_ips
      roles     = ["etcd", "controlplane", "worker"]

    }
  ]
  cluster_name       = var.cluster_name
  kubernetes_version = var.kubernetes_version
  prefix             = var.prefix
  dependency         = var.dependency
}


provider "helm" {
  kubernetes {
    config_path = module.rke.rke_kubeconfig_filename
  }
}

provider "kubernetes" {
  config_path = module.rke.rke_kubeconfig_filename
  insecure    = true
}

module "rancher_install" {
  source = "../../../../modules/rancher"
  #  depends_on                 = [module.rke]
  # TODO: Fix this as conditional
  rancher_hostname           = join(".", ["rancher", module.upstream-cluster.ip_addresses[0], "sslip.io"])
  rancher_replicas           = var.rancher_replicas
  rancher_bootstrap_password = var.rancher_bootstrap_password
  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
  dependency = var.dependency
}
