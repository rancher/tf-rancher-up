output "instances_public_ip" {
  value = module.aws_ec2_upstream_cluster.instances_public_ip
}

output "instances_private_ip" {
  value = module.aws_ec2_upstream_cluster.instances_private_ip
}

output "kube_config_path" {
  value = module.rke.kube_config_yaml
}
