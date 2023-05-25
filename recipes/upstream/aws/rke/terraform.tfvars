###### !! Required variables !! ######

## -- Terraform will use the default ~/.aws/credentials file or environment variables to determine the access/secret keys. Uncomment the below only if necessary.
# aws_access_key = "ACCESS_KEY_HERE"
# aws_secret_key = "SECRET_KEY_HERE"
aws_region = "ap-southeast-2"

## -- Set the prefix for the name tag on instancrease created. A default prefix (rancher-terraform) if not provided.
prefix = "prefix_for_cluster"

###### !! Optional variables !! ######

## -- Password to set when installing Rancher, otherwise use default (initial-admin-password)
# rancher_password = "at-least-12-characters"

## -- Rancher version to use when installing the Rancher helm chart, otherwise use the latest in the stable repository
# rancher_version = "2.7.3"

## -- Override the default k8s version used by RKE
# kubernetes_version = "v1.24.10-rancher4-1"

## -- Number of EC2 instances to launch
instance_count = 1

##### SSH
## -- (A) Create a new keypair in AWS
create_ssh_key_pair = true
## -- Override the default (./${prefix}_ssh_private_key.pem) path where this SSH key is written
# ssh_private_key_path = "/path/to/private/key.pem"

## -- (B) Provide an existing keypair name in AWS to use for nodes, the matching private key file for this keypair also must be provided so RKE can SSH to the launched nodes
# ssh_key_pair_name = "aws_keypair_name"
# ssh_key_pair_path  = "/path/to/private/key.pem"
#####

## -- Override the default (${prefix}_kube_config.yml) kubeconfig file/path
# kube_config_path = "~/.kube/rancher-terraform.yml"