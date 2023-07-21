output "vsphere_virtual_machines_ip_addresses" {
  value       = vsphere_virtual_machine.instance[*].guest_ip_addresses
  description = "VM IPs"
}

output "rancher_ip" {
  value       = vsphere_virtual_machine.instance[0].guest_ip_addresses[0]
  description = "This output will get IP from the first VM on which Rancher will be installed."
}

output "dependency" {
  description = "A description of this output"
  value       = var.instance_count != 0 ? vsphere_virtual_machine.instance[0].guest_ip_addresses[0] : null
}

