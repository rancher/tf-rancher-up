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

output "ssh_key" {
  value = var.create_ssh_key_pair ? tls_private_key.ssh_private_key[0].private_key_openssh : (var.ssh_key_pair_path != null ? file(pathexpand(var.ssh_key_pair_path)) : var.ssh_key)
}

output "ssh_key_path" {
  value = var.create_ssh_key_pair ? local_file.private_key_pem[0].filename : var.ssh_key_pair_path
}

output "ssh_key_pair_name" {
  value = var.create_ssh_key_pair ? aws_key_pair.key_pair[0].key_name : var.ssh_key_pair_name
}

output "sg-id" {
  value = var.create_security_group ? aws_security_group.sg_allowall[0].id : var.instance_security_group
}