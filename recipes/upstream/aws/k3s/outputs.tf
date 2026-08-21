output "instances_public_ip" {
  value = concat([module.k3s_first_server.instances_public_ip], [module.k3s_additional_servers.instances_public_ip])
}

output "instances_private_ip" {
  value = concat([module.k3s_first_server.instances_private_ip], [module.k3s_additional_servers.instances_private_ip])
}

output "rancher_hostname" {
  value = local.rancher_hostname
}

output "rancher_url" {
  value = "https://${local.rancher_hostname}"
}

output "rancher_admin_token" {
  description = "Rancher API token for the admin user"
  value       = module.rancher_install.rancher_admin_token
  sensitive   = true
}

output "client_public_ip" {
  value = var.restricted_access == true ? module.k3s_first_server.client_public_ip : null
}

output "vpc_id" {
  description = "VPC ID used by the Rancher environment"
  value       = module.k3s_first_server.vpc_id
}

output "subnets" {
  description = "Subnets used by the Rancher environment"
  value       = module.k3s_first_server.public_subnets != null ? module.k3s_first_server.public_subnets : var.subnet_id
}

output "aws_region" {
  description = "AWS region used for the cluster"
  value       = var.aws_region
}

output "aws_cloud_credential_id" {
  description = "The ID of the AWS cloud credential created in Rancher"
  value       = module.rancher_install.aws_cloud_credential_id
}

output "ssh_username" {
  description = "Username used for SSH access to the nodes"
  value       = module.k3s_first_server.node_username
}
