output "dependency" {
  value = [
    var.master_nodes_count != 0 ? module.master_nodes[*].instance_ips : null,
    var.worker_nodes_count != 0 ? module.worker_nodes[*].instance_ips : null
  ]
}

output "kubeconfig_file" {
  value = module.rke.rke_kubeconfig_filename
}
