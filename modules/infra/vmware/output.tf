output "instances_private_ip" {
  description = "Private IP addresses of VMs"
  value       = vsphere_virtual_machine.instance[*].default_ip_address
}

output "instances_public_ip" {
  description = "Public IP addresses of VMs (same as private for on-prem)"
  value       = vsphere_virtual_machine.instance[*].default_ip_address
}

output "vm_ids" {
  description = "VM instance IDs"
  value       = vsphere_virtual_machine.instance[*].id
}

output "ssh_key_path" {
  description = "Path to SSH private key"
  value       = local.ssh_private_key_path
}

output "ssh_public_key" {
  description = "SSH public key used for VMs"
  value       = var.create_ssh_key_pair ? tls_private_key.ssh_key[0].public_key_openssh : var.ssh_public_key
}

output "dependency" {
  description = "Dependency output for chaining resources"
  value       = var.instance_count > 0 ? vsphere_virtual_machine.instance[0].id : null
}
