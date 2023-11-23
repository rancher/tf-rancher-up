output "instances_private_ip" {
  value = concat([module.rke2-first-server.instances_public_ip], [module.rke2-additional-servers.instances_public_ip])
}

output "instances_public_ip" {
  value = concat([module.rke2-first-server.instances_private_ip], [module.rke2-additional-servers.instances_private_ip])
}

locals {
  rancher_url = var.rancher_hostname != "" ? "https://${module.rancher_install.rancher_hostname}:${data.kubernetes_service.rke2-ingress-nginx-controller-svc.spec.0.port.0.node_port}" : "https://rancher:${data.kubernetes_service.rke2-ingress-nginx-controller-svc.spec.0.port.0.node_port}"
}

#output "rke2_first_server_config_file" {
#  value = nonsensitive(module.rke2-first.rke2_user_data)
#}

#output "rke2_additional_servers_config_file" {
#  value = nonsensitive(module.rke2-additional.rke2_user_data)
#}

#output "rancher_url" {
#  description = "Rancher URL"
#  value       = local.rancher_url
#}

output "rancher_password" {
  description = "Rancher Initial Custom Password"
  value       = var.rancher_password
}

#output "ingress_nginx_stats" {
#  value = data.kubernetes_service.ingress-nginx-controller-svc.spec.0.port.1.node_port
#}
