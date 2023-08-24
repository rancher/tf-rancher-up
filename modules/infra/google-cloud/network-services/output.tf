output "vpc_name" {
  value       = google_compute_network.vpc.name
  description = "VPC Name"
}

output "subnet_name" {
  value       = google_compute_subnetwork.subnet.name
  description = "Subnet Name"
}
