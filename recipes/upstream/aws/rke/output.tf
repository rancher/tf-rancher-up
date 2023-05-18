output "instances_public_ip" {
  value = module.upstream-cluster.instances_public_ip
}

output "instances_private_ip" {
  value =  module.upstream-cluster.instances_private_ip
}
