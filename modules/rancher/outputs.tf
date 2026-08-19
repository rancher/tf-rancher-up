output "rancher_hostname" {
  description = "Value for hostname when installing the Rancher helm chart"
  value       = var.rancher_hostname
}

output "rancher_bootstrap_password" {
  description = "Password used to install Rancher"
  value       = var.rancher_password
  sensitive   = true
}

output "rancher_password" {
  description = "Password for the Rancher admin account"
  value       = var.rancher_password
  sensitive   = true
}

output "rancher_admin_token" {
  description = "Rancher API token for the admin user"
  value       = one(rancher2_bootstrap.admin[*].token)
  sensitive   = true
}

output "aws_cloud_credential_id" {
  description = "The ID of the AWS cloud credential created in Rancher"
  value       = length(rancher2_cloud_credential.aws) > 0 ? rancher2_cloud_credential.aws[0].id : null
}
