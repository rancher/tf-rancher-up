# Custom Downstream Cluster Recipe

This recipe creates a custom downstream cluster in Rancher and outputs the registration command.

## Usage

1. Copy `terraform.tfvars.example` to `terraform.tfvars` and fill in your details.
2. Run `terraform init`.
3. Run `terraform apply`.
4. Copy either the `node_command` (secure) or `insecure_node_command` from the output and run it on your external VMs to register them as nodes.
