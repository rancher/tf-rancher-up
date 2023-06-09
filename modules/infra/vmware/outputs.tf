output "ip_addresses" {
  value       = vsphere_virtual_machine.instance[*].default_ip_address
  description = "VM IPs"
}
