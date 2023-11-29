output "instances_private_ip" {
  value       = google_compute_instance.default.*.network_interface.0.network_ip
  description = "Google Compute Engine Intances Private IPs"
}

output "instances_public_ip" {
  value       = google_compute_instance.default.*.network_interface.0.access_config.0.nat_ip
  description = "Google Compute Engine Intances Public IPs"
}

output "instance_ips" {
  value = [
    for i in google_compute_instance.default.*.network_interface.0 :
    {
      public_ip  = i.access_config.0.nat_ip
      private_ip = i.network_ip
    }
  ]
}
