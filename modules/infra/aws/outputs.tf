output "instances_public_ip" {
  value = aws_instance.instance.*.public_ip
}

output "instances_private_ip" {
  value = aws_instance.instance.*.private_ip
}

output "instances_ips" {
  value = [
  for i in aws_instance.instance[*]:
    {
      public_ip = i.public_ip
      private_ip = i.private_ip
    }
  ]
}