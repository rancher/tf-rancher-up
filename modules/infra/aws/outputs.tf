output "dependency" {
  value = aws_instance.instance[0].arn
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
      public_ip  = i.public_ip
      private_ip = i.private_ip
    }
  ]
}

output "ssh_key_path" {
  depends_on = [aws_instance.instance[0]]
  value      = local.create_new_key_pair ? local_file.private_key_pem[0].filename : var.ssh_key_pair_path
}

output "sg-id" {
  value = var.create_security_group ? aws_security_group.sg_allowall[0].id : var.instance_security_group
}