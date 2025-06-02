output "public_ssh_key" {
  value = var.create_ssh_key_pair ? tls_private_key.ssh_private_key[0].public_key_openssh : local.public_ssh_key_path
}

output "instances_private_ip" {
  value       = azurerm_linux_virtual_machine.vm.*.private_ip_address
  description = "Azure Virtual Machines Private IPs"
}

output "instances_public_ip" {
  value       = azurerm_linux_virtual_machine.vm.*.public_ip_address
  description = "Azure Virtual Machines Public IPs"
}


output "instance_ips" {
  value = [
    for i in azurerm_linux_virtual_machine.vm.* :
    {
      public_ip  = i.public_ip_address
      private_ip = i.private_ip_address
    }
  ]
}

output "resource_group_name" {
  value = var.create_rg ? azurerm_resource_group.rg[0].name : null
}

output "resource_group_location" {
  value = var.create_rg ? azurerm_resource_group.rg[0].location : null
}

output "network_security_group_id" {
  value = var.create_firewall ? azurerm_network_security_group.nsg[0].id : null
}

output "vnet" {
  value = azurerm_virtual_network.vnet
}

output "subnet" {
  value = azurerm_subnet.subnet
}

output "firewall_inbound" {
  value = azurerm_network_security_rule.allow_inbound
}

output "firewall_outbound" {
  value = azurerm_network_security_rule.allow_outbound
}