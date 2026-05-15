# Imported Cluster Recipe

This recipe imports an existing Kubernetes cluster into Rancher.

## Usage

1. Copy `terraform.tfvars.example` to `terraform.tfvars` and fill in the values.
2. Run `terraform init`.
3. Run `terraform apply`.
4. Run either the `kubectl_apply_command` (secure) or `insecure_kubectl_apply_command` outputted by Terraform on your existing cluster.
