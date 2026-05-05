data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Support cluster, host, or explicit resource pool
data "vsphere_compute_cluster" "cluster" {
  count         = var.vsphere_cluster != null ? 1 : 0
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "host" {
  count         = var.vsphere_host != null ? 1 : 0
  name          = var.vsphere_host
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  count         = var.vsphere_resource_pool != null ? 1 : 0
  name          = var.vsphere_resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Determine resource pool based on what's provided
locals {
  resource_pool_id = (
    var.vsphere_cluster != null ? data.vsphere_compute_cluster.cluster[0].resource_pool_id :
    var.vsphere_host != null ? data.vsphere_host.host[0].resource_pool_id :
    data.vsphere_resource_pool.pool[0].id
  )
}

# Optional folder for VM organization
data "vsphere_folder" "folder" {
  count = var.vsphere_folder != null ? 1 : 0
  path  = "${var.vsphere_datacenter}/vm/${var.vsphere_folder}"
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vsphere_virtual_machine
  datacenter_id = data.vsphere_datacenter.dc.id
}
