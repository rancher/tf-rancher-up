# Upstream | AWS | RKE2

This module is used to establish a Rancher (local) managment cluster using AWS and RKE2.

## Usage

```bash
git clone https://github.com/rancherlabs/tf-rancher-up.git
cd recipes/upstream/aws/rke2
```

- Copy `terraform.tfvars.exmaple` to `terraform.tfvars`
- Edit `terraform.tfvars`
  - Update the required variables:
    -  `aws_region` to suit your region
    -  `prefix` to give the resources an identifiable name (eg, your initials or first name)
    -  Recommended: `spot_instances` can be set to `true` to use spot instances
- Check your AWS credentials are configured in `~/.aws/credentials`, terraform will use these by default. See [the `aws configure` command](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html#cli-configure-files-methods) on how to do this

  > If storing multiple AWS credentials in `~/.aws/credentials`, set the profile when running terraform:
  ```bash
  AWS_PROFILE=<profile name> terraform apply
  ```

```bash
terraform init
terraform apply
```

**Note** you may need to use ` terraform init -upgrade` to upgrade provider versions

- Destroy the resources when finished
```bash
terraform destroy
```

### Notes

The user data automatically sets up each node for use with `kubectl` (also alias to `k`) and `crictl` when logged in

See full argument list for each module in use:
  - AWS: https://github.com/rancherlabs/tf-rancher-up/tree/main/modules/infra/aws
  - RKE2: https://github.com/rancherlabs/tf-rancher-up/tree/main/modules/distribution/rke2
  - Rancher: https://github.com/rancherlabs/tf-rancher-up/tree/main/modules/rancher

---

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_ssh"></a> [ssh](#requirement\_ssh) | 2.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | 2.4.0 |
| <a name="provider_ssh"></a> [ssh](#provider\_ssh) | 2.6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rancher_install"></a> [rancher\_install](#module\_rancher\_install) | ../../../../modules/rancher | n/a |
| <a name="module_rke2_additional"></a> [rke2\_additional](#module\_rke2\_additional) | ../../../../modules/distribution/rke2 | n/a |
| <a name="module_rke2_additional_servers"></a> [rke2\_additional\_servers](#module\_rke2\_additional\_servers) | ../../../../modules/infra/aws | n/a |
| <a name="module_rke2_first"></a> [rke2\_first](#module\_rke2\_first) | ../../../../modules/distribution/rke2 | n/a |
| <a name="module_rke2_first_server"></a> [rke2\_first\_server](#module\_rke2\_first\_server) | ../../../../modules/infra/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [local_file.kube_config_server_yaml](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [ssh_resource.retrieve_kubeconfig](https://registry.terraform.io/providers/loafoe/ssh/2.6.0/docs/resources/resource) | resource |
| [local_file.ssh_private_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | AWS access key used to create infrastructure | `string` | `null` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region used for all resources | `string` | n/a | yes |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | AWS secret key used to create AWS infrastructure | `string` | `null` | no |
| <a name="input_create_ssh_key_pair"></a> [create\_ssh\_key\_pair](#input\_create\_ssh\_key\_pair) | Specify if a new SSH key pair needs to be created for the instances | `bool` | `false` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of EC2 instances to create | `number` | `3` | no |
| <a name="input_kube_config_path"></a> [kube\_config\_path](#input\_kube\_config\_path) | The path to write the kubeconfig for the RKE cluster | `string` | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix added to names of all resources | `string` | `null` | no |
| <a name="input_rancher_password"></a> [rancher\_password](#input\_rancher\_password) | Password to use for bootstrapping Rancher (min 12 characters) | `string` | `"initial-admin-password"` | no |
| <a name="input_rancher_version"></a> [rancher\_version](#input\_rancher\_version) | Rancher version to install | `string` | `null` | no |
| <a name="input_rke2_config"></a> [rke2\_config](#input\_rke2\_config) | Additional RKE2 configuration to add to the config.yaml file | `any` | `null` | no |
| <a name="input_rke2_token"></a> [rke2\_token](#input\_rke2\_token) | Token to use when configuring RKE2 nodes | `any` | `null` | no |
| <a name="input_rke2_version"></a> [rke2\_version](#input\_rke2\_version) | Kubernetes version to use for the RKE2 cluster | `string` | `null` | no |
| <a name="input_spot_instances"></a> [spot\_instances](#input\_spot\_instances) | Use spot instances | `bool` | `false` | no |
| <a name="input_ssh_key_pair_name"></a> [ssh\_key\_pair\_name](#input\_ssh\_key\_pair\_name) | Specify the SSH key name to use (that's already present in AWS) | `string` | `null` | no |
| <a name="input_ssh_key_pair_path"></a> [ssh\_key\_pair\_path](#input\_ssh\_key\_pair\_path) | Path to the SSH private key used as the key pair (that's already present in AWS) | `string` | `null` | no |
| <a name="input_ssh_username"></a> [ssh\_username](#input\_ssh\_username) | Username used for SSH with sudo access | `string` | `"ubuntu"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instances_private_ip"></a> [instances\_private\_ip](#output\_instances\_private\_ip) | n/a |
| <a name="output_instances_public_ip"></a> [instances\_public\_ip](#output\_instances\_public\_ip) | n/a |
| <a name="output_rancher_hostname"></a> [rancher\_hostname](#output\_rancher\_hostname) | n/a |
| <a name="output_rancher_password"></a> [rancher\_password](#output\_rancher\_password) | n/a |