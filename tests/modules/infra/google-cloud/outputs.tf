output "instances_private_ip" {
  value       = module.google-compute-engine.instances_private_ip
  description = "Google Compute Engine Intances Private IPs"
}

output "instances_public_ip" {
  value       = module.google-compute-engine.instances_public_ip
  description = "Google Compute Engine Intances Public IPs"
}
