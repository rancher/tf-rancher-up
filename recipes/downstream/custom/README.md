# Custom Downstream Cluster Recipe

This recipe creates a custom RKE2 or k3s downstream cluster in Rancher and outputs the registration command to join existing nodes.

## Usage

- Copy `terraform.tfvars.example` to `terraform.tfvars` and fill in your details.
- Run `terraform init`.
- Run `terraform apply`.
- Copy either the `node_command` (secure) or `insecure_node_command` from the output and run it on your external VMs to register them as nodes.
