# Upstream | AWS | RKE

This module is used to establish a Rancher (local) managment cluster using AWS and RKE.

## Usage

```bash
git clone https://github.com/rancherlabs/tf-rancher-up.git
cd recipes/upstream/aws/rke
```

- Edit terraform.tfvars
  - As a minimum update the AWS region and prefix
- Check your AWS credentials are configured in ~/.aws/credentials

```bash
terraform init
terraform apply
```

- If using multiple AWS credentials, configure the profile when running terraform:
```bash
AWS_PROFILE=<profile name> terraform apply
```

### Advanced

Target a specific resource/module to action the changes only for that resource/module

For example, target only the `rke_cluster` resource to re-run the equivalent of `rke up`:

```bash
terraform apply -target module.rke.rke_cluster.this
```

### Notes

A log file for the RKE provisioning is written to `rke.log`

See full argument list for each module in use:
  - AWS: https://github.com/rancherlabs/tf-rancher-up/tree/main/modules/infra/aws
  - RKE: https://github.com/rancherlabs/tf-rancher-up/tree/main/modules/distribution/rke
  - Rancher: https://github.com/rancherlabs/tf-rancher-up/tree/main/modules/rancher

---

## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rancher_install"></a> [rancher\_install](#module\_rancher\_install) | ../../../../modules/rancher | n/a |
| <a name="module_rke"></a> [rke](#module\_rke) | ../../../../modules/distribution/rke | n/a |
| <a name="module_upstream-cluster"></a> [upstream-cluster](#module\_upstream-cluster) | ../../../../modules/infra/aws | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | AWS access key used to create infrastructure | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region used for all resources | `string` | `"us-east-1"` | no |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | AWS secret key used to create AWS infrastructure | `string` | `null` | no |
| <a name="input_create_ssh_key_pair"></a> [create\_ssh\_key\_pair](#input\_create\_ssh\_key\_pair) | Specify if a new SSH key pair needs to be created for the instances | `bool` | `false` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of EC2 instances to create | `number` | `3` | no |
| <a name="input_kube_config_path"></a> [kube\_config\_path](#input\_kube\_config\_path) | The path to write the kubeconfig for the RKE cluster | `string` | `null` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version to use for the RKE cluster | `string` | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix added to names of all resources | `string` | `null` | no |
| <a name="input_rancher_password"></a> [rancher\_password](#input\_rancher\_password) | Password to use for bootstrapping Rancher (min 12 characters) | `string` | `"initial-admin-password"` | no |
| <a name="input_rancher_version"></a> [rancher\_version](#input\_rancher\_version) | Rancher version to install | `string` | `null` | no |
| <a name="input_ssh_key_pair_name"></a> [ssh\_key\_pair\_name](#input\_ssh\_key\_pair\_name) | Specify the SSH key name to use (that's already present in AWS) | `string` | `null` | no |
| <a name="input_ssh_key_pair_path"></a> [ssh\_key\_pair\_path](#input\_ssh\_key\_pair\_path) | Path to the SSH private key used as the key pair (that's already present in AWS) | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instances_private_ip"></a> [instances\_private\_ip](#output\_instances\_private\_ip) | n/a |
| <a name="output_instances_public_ip"></a> [instances\_public\_ip](#output\_instances\_public\_ip) | n/a |
| <a name="output_rancher_hostname"></a> [rancher\_hostname](#output\_rancher\_hostname) | n/a |
| <a name="output_rancher_password"></a> [rancher\_password](#output\_rancher\_password) | n/a |