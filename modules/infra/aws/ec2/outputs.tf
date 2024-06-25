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

output "sg-id" {
  value = var.create_security_group == true ? aws_security_group.sg_allowall[0].id : var.instance_security_group_id
}
