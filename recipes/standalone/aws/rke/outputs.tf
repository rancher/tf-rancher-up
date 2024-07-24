output "instances_public_ip" {
  value = module.cluster-nodes.instances_public_ip
}

output "instances_private_ip" {
  value = module.cluster-nodes.instances_private_ip
}

output "dependency" {
  value = module.rke.dependency
}

output "kubeconfig_filename" {
  value = module.rke.rke_kubeconfig_filename
}

output "kubeconfig_yaml" {
  value = module.rke.kube_config_yaml
}
