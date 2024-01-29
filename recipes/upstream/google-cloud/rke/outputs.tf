output "instances_private_ip" {
  value = module.google-compute-engine-upstream-cluster.instances_private_ip
}

output "instances_public_ip" {
  value = module.google-compute-engine-upstream-cluster.instances_public_ip
}

output "rancher_url" {
  description = "Rancher URL"
  value       = "https://${module.rancher_install.rancher_hostname}"
}

output "rancher_password" {
  description = "Rancher Initial Custom Password"
  value       = var.rancher_password
}

#output "ingress_nginx_stats" {
#  value = data.kubernetes_service.ingress-nginx-controller-svc.spec.0.port.1.node_port
#}
