# output "rancher_ip" {
#   value = module.upstream-cluster.vsphere_virtual_machine[0][0]
# }

# output "upstream-cluster" {
#   value = module.upstream-cluster.vsphere_virtual_machine[0][4]
# }

# output "kube_config_yaml" {
#   value = module.rke.rke_kubeconfig_filename
# }

# output "node_ips" {
#   value = module.upstream-cluster
# }

# output "rancher_ip_to_use" {
#   value = module.upstream-cluster.rancher_ip
# }

output "rancher_url" {
  value = join(".", ["rancher", module.upstream-cluster.rancher_ip, "sslip.io"])
}