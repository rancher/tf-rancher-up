module "rke2_first" {
  source       = "../../../../modules/distribution/rke2"
  rke2_token   = var.rke2_token
  rke2_version = var.rke2_version
  rke2_config  = var.rke2_config
}

module "rke2_first_server" {
  source                  = "../../../../modules/infra/vmware"
  ssh_private_key_path    = var.ssh_private_key_path
  instance_count          = 1
  vsphere_datacenter      = var.vsphere_datacenter
  vsphere_resource_pool   = var.vsphere_resource_pool
  vsphere_datastore       = var.vsphere_datastore
  vsphere_virtual_machine = var.vsphere_virtual_machine
  vsphere_network         = var.vsphere_network
  vsphere_user            = var.vsphere_user
  authorized_keys         = var.authorized_keys
  prefix                  = "${var.prefix}-first"
  vsphere_server          = var.vsphere_server
  vsphere_server_allow_unverified_ssl = var.vsphere_server_allow_unverified_ssl
  vsphere_password        = var.vsphere_password
  vm_username             = var.vm_username
}


module "rke2_additional" {
  source          = "../../../../modules/distribution/rke2"
  rke2_token      = module.rke2_first.rke2_token
  rke2_version    = var.rke2_version
  rke2_config     = var.rke2_config
  first_server_ip = module.rke2_first_server.rancher_ip
}



module "rke2_additional_servers" {
  source                  = "../../../../modules/infra/vmware"
  ssh_private_key_path    = var.ssh_private_key_path
  instance_count          = var.instance_count - 1
  vsphere_datacenter      = var.vsphere_datacenter
  vsphere_resource_pool   = var.vsphere_resource_pool
  vsphere_datastore       = var.vsphere_datastore
  vsphere_virtual_machine = var.vsphere_virtual_machine
  vsphere_network         = var.vsphere_network
  vsphere_user            = var.vsphere_user
  authorized_keys         = var.authorized_keys
  prefix                  = var.prefix
  vsphere_server          = var.vsphere_server
  vsphere_server_allow_unverified_ssl = var.vsphere_server_allow_unverified_ssl
  vsphere_password        = var.vsphere_password
  vm_username             = var.vm_username
}

resource "ssh_resource" "retrieve_kubeconfig" {
  host = module.rke2_first_server.rancher_ip
  commands = [
    "sudo sed 's/127.0.0.1/${module.rke2_first_server.rancher_ip}/g' /etc/rancher/rke2/rke2.yaml"
  ]
  user        = var.vm_username
  private_key = file("${var.ssh_private_key_path}")
}

resource "local_file" "kube_config_server_yaml" {
  filename = var.kube_config_path != null ? var.kube_config_path : "${path.cwd}/${var.prefix}_kube_config.yml"
  content  = ssh_resource.retrieve_kubeconfig.result
}

module "rancher_install" {
  source                     = "../../../../modules/rancher"
  kubeconfig_file            = local_file.kube_config_server_yaml.filename
  rancher_hostname           = join(".", ["rancher", module.rke2_first_server.rancher_ip, "sslip.io"])
  rancher_replicas           = var.instance_count
  rancher_bootstrap_password = var.rancher_password
  rancher_version            = var.rancher_version
  dependency                 = var.instance_count > 1 ? module.rke2_additional_servers.dependency : module.rke2_first_server.dependency
}

