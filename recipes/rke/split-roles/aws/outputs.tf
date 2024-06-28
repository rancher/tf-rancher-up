output "instances_private_ip" {
  value = concat([module.aws-ec2-upstream-master-nodes.instances_private_ip], [module.aws-ec2-upstream-worker-nodes.instances_private_ip])
}

output "instances_public_ip" {
  value = concat([module.aws-ec2-upstream-master-nodes.instances_public_ip], [module.aws-ec2-upstream-worker-nodes.instances_public_ip])
}

output "vpc" {
  value = module.aws-ec2-upstream-master-nodes.vpc[0].id
}

output "subnet" {
  value = module.aws-ec2-upstream-master-nodes.subnet[0].id
}

output "security_group" {
  value = module.aws-ec2-upstream-master-nodes.security_group[0].id
}

output "rancher_url" {
  description = "Rancher URL"
  value       = "https://${module.rancher_install.rancher_hostname}"
}

output "rancher_password" {
  description = "Rancher Initial Custom Password"
  value       = var.rancher_password
}
