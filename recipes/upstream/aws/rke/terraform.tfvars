## Terraform will use the default ~/.aws/credentials or environment variables to determine the access/secret keys. Uncomment the below only if necessary.
# aws_access_key = "ACCESS_KEY_HERE"
# aws_secret_key = "SECRET_KEY_HERE"
aws_region = "ap-southeast-2"

## Set the prefix for the name tag on instancrease created. A default prefix (rancher-terraform) if not provided.
prefix = "prefix_for_cluster"

## Optional: password to set when installing Rancher, otherwise use default (initial-admin-password)
# rancher_password = "at-least-12-characters"

## Optional: version to use when installing Rancher, otherwise use stable repository latest
# rancher_version = "2.7.3"

##### SSH
## Create a new keypair in AWS
create_ssh_key_pair = true
## Optional: override the default (./${prefix}_ssh_private_key.pem) path where this SSH key is written
# ssh_private_key_path = "/path/to/private/key.pem"

## Optional: provide an existing keypair name in AWS to use for nodes, the matching private key file for this keypair also must be provided so RKE can SSH to the launched nodes
# ssh_key_pair_name = "aws_keypair_name"
# ssh_key_pair_path  = "/path/to/private/key.pem"
#####

## Optional: override the default (${prefix}_kube_config.yml)
# kube_config_path = "~/.kube/rancher-terraform.yml"

## Number of EC2 instances to launch
instance_count = 1

## Optional: override the default k8s version used by RKE
# kubernetes_version = "v1.24.10-rancher4-1"