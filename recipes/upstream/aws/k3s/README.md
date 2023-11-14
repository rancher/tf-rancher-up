# Upstream | AWS | K3S

This module is used to establish a Rancher (local) management cluster using AWS and K3S.

## Usage

```bash
git clone https://github.com/rancherlabs/tf-rancher-up.git
cd recipes/upstream/aws/k3s
```

- Copy `terraform.tfvars.example` to `terraform.tfvars`
- Edit `terraform.tfvars`
  - Update the required variables:
    -  `aws_region` to suit your region
    -  uncomment `instance_type` and change the instance type if needed.
    -  `prefix` to give the resources an identifiable name (eg, your initials or first name)
    -  Recommended: `spot_instances` can be set to `true` to use spot instances
- Check your AWS credentials are configured in `~/.aws/credentials`, terraform will use these by default. Refer the [`aws configure`](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html#cli-configure-files-methods) command on how to do this.
- If you don't want to configure AWS credentials using `aws configure` in above step, uncomment `aws_access_key` and `aws_secret_key` in `terraform.tfvars` and input the required keys there.
- If an HA cluster need to be deployed, change the `instance_count` variable to 3 or more.
- There are more optional variables which can be tweaked under `terraform.tfvars`.

**NOTE** you may need to use ` terraform init -upgrade` to upgrade provider versions

Execute the below commands to start deployment.

```bash
terraform init
terraform plan -var-file terraform.tfvars
terraform apply -var-file terraform.tfvars
```
The login details will be displayed in the screen once the deployment is successful. It will have the details as below.

```bash
rancher_hostname = "https://rancher.<xx.xx.xx.xx>.sslip.io"
rancher_password = "initial-admin-password"
```

- If storing multiple AWS credentials in `~/.aws/credentials`, set the profile when running terraform.

```bash
AWS_PROFILE=<profile name> terraform plan -var-file terraform.tfvars
AWS_PROFILE=<profile name> terraform apply -var-file terraform.tfvars
```

- Destroy the resources when cluster is no more needed.
```bash
terraform destroy -var-file terraform.tfvars
```
**IMPORTANT**: Please retire the services which are deployed using these terraform modules within 48 hours. Soon there will be automation to retire the service automatically after 48 hours but till that is in place it will be the users responsibility to not keep it running more than 48 hours.

### Notes

The user data automatically sets up each node for use with kubectl (also alias to k) and crictl when logged in.

See full argument list for each module in use:
  - [AWS](../../../../modules/infra/aws)
  - [K3S](../../../../modules/distribution/k3s)
  - [Rancher](../../../../modules/rancher)

### Known Issues
- Terraform plan shows below warnings which can be ignored:

```bash
Warning: Value for undeclared variable

The root module does not declare a variable named "ssh_private_key_path" but a value was found in file "terraform.tfvars". If you meant to use this value, add a "variable" block to the configuration.

Invalid attribute in provider configuration

with module.rancher_install.provider["registry.terraform.io/hashicorp/kubernetes"],
on ../../../../modules/rancher/provider.tf line 7, in provider "kubernetes":
7: provider "kubernetes" {
```
- Terraform apply shows below warnings and errors. Please rerun the terraform apply again and it will be successful[(Issue #22)](#22).

```bash
Warning: 

Helm release "rancher" was created but has a failed status. Use the `helm` command to investigate the error, correct it, then run Terraform again.

Error: 1 error occurred:
* Internal error occurred: failed calling webhook "validate.nginx.ingress.kubernetes.io": failed to call webhook: Post "https://rke2-ingress-nginx-controller-admission.kube-system.svc:443/networking/v1/ingresses?timeout=10s": no endpoints available for service "rke2-ingress-nginx-controller-admission"
```

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
| <a name="module_k3s_additional"></a> [k3s\_additional](#module\_k3s\_additional) | ../../../../modules/distribution/k3s | n/a |
| <a name="module_k3s_additional_servers"></a> [k3s\_additional\_servers](#module\_k3s\_additional\_servers) | ../../../../modules/infra/aws | n/a |
| <a name="module_k3s_first"></a> [k3s\_first](#module\_k3s\_first) | ../../../../modules/distribution/k3s | n/a |
| <a name="module_k3s_first_server"></a> [k3s\_first\_server](#module\_k3s\_first\_server) | ../../../../modules/infra/aws | n/a |

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
| <a name="input_k3s_config"></a> [k3s\_config](#input\_k3s\_config) | Additional k3s configuration to add to the config.yaml file | `any` | `null` | no |
| <a name="input_k3s_token"></a> [k3s\_token](#input\_k3s\_token) | Token to use when configuring k3s nodes | `any` | `null` | no |
| <a name="input_k3s_version"></a> [k3s\_version](#input\_k3s\_version) | Kubernetes version to use for the k3s cluster | `string` | `null` | no |
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
