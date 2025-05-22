output "dependency" {
  value = var.instance_count != 0 ? aws_instance.instance[0].arn : null
}

output "instances_public_ip" {
  value = aws_instance.instance.*.public_ip
}

output "instances_private_ip" {
  value = aws_instance.instance.*.private_ip
}

output "instance_ips" {
  value = [
    for i in aws_instance.instance[*] :
    {
      public_ip   = i.public_ip
      private_ip  = i.private_ip
      private_dns = i.private_dns
    }
  ]
}

output "node_username" {
  value = var.ssh_username
}

output "ssh_key_path" {
  value = var.create_ssh_key_pair ? local_file.private_key_pem[0].filename : var.ssh_key_pair_path != null ? var.ssh_key_pair_path : null
}

output "ssh_key_pair_name" {
  value = var.create_ssh_key_pair ? aws_key_pair.key_pair[0].key_name : var.ssh_key_pair_name
}

output "public_subnets" {
  value = var.create_vpc == true ? module.aws_vpc[0].public_subnets : tolist(local.existing_subnet)
}

output "private_subnets" {
  value = var.create_vpc == true ? module.aws_vpc[0].private_subnets : null
}

output "vpc_id" {
  value = var.create_vpc == true ? module.aws_vpc[0].vpc_id : null
}

output "sg-id" {
  value = var.create_security_group ? aws_security_group.sg_allowall[0].id : var.instance_security_group
}

output "client_public_ip" {
  value = var.restricted_access == true ? "${chomp(data.http.client_public_ip[0].response_body)}" : null
}