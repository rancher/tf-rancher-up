provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = var.vsphere_server_allow_unverified_ssl
}

module "upstream-cluster" {
  source = "../../../../modules/infra/vmware"
  ssh_private_key_path  = var.ssh_private_key_path
  vsphere_datacenter = var.vsphere_datacenter
  vsphere_resource_pool = var.vsphere_resource_pool
  vsphere_datastore = var.vsphere_datastore
  vsphere_virtual_machine = var.vsphere_virtual_machine
  vsphere_network = var.vsphere_network
}

module "rke" {
  source     = "../../../../modules/distribution/rke"
  depends_on = [module.upstream-cluster]

  node_username        = "ubuntu"
  ssh_private_key_path = var.ssh_private_key_path

  rancher_nodes = [for instance_ips in module.upstream-cluster.vsphere_virtual_machine[*][0] :
    {
      public_ip  = instance_ips
      roles = ["etcd", "controlplane", "worker"]
      
    }
  ]
}


provider "helm" {
  kubernetes {
    config_path = "${path.module}/${module.rke.rke_kubeconfig_filename}"
  }
}

provider "kubernetes" {
  config_path = "${path.module}/${module.rke.rke_kubeconfig_filename}"
  insecure    = true
}

module "rancher_install" {
  source = "../../../../modules/rancher"
  depends_on = [module.rke]
  rancher_hostname = join(".", ["rancher", module.upstream-cluster.rancher_ip, "sslip.io"])
  rancher_replicas  = 1
  rancher_bootstrap_password = "changeme"
  providers = {
    kubernetes = kubernetes
    helm = helm
  }
}
