# Imported Cluster Recipe

This recipe imports an existing Kubernetes cluster into Rancher. It provides the registration command to be applied on the existing downstream cluster.

## Usage

- Copy `terraform.tfvars.example` to `terraform.tfvars` and fill in the values.
- Run `terraform init`.
- Run `terraform apply`.
- Run either the `command` (secure) or `insecure_command` in the outputs on your existing cluster.