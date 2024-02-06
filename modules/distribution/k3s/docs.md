## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [random_password.token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dependency"></a> [dependency](#input\_dependency) | An optional variable to add a dependency from another resource (not used) | `any` | `null` | no |
| <a name="input_first_server_ip"></a> [first\_server\_ip](#input\_first\_server\_ip) | Internal IP address for the first k3s-server node | `string` | `null` | no |
| <a name="input_k3s_channel"></a> [k3s\_channel](#input\_k3s\_channel) | K3s channel to use, the latest patch version for the provided minor version will be used | `string` | `null` | no |
| <a name="input_k3s_config"></a> [k3s\_config](#input\_k3s\_config) | Additional k3s configuration to add to the config.yaml file | `any` | `null` | no |
| <a name="input_k3s_token"></a> [k3s\_token](#input\_k3s\_token) | Token to use when configuring k3s nodes | `any` | `null` | no |
| <a name="input_k3s_version"></a> [k3s\_version](#input\_k3s\_version) | Kubernetes version to use for the k3s cluster | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_k3s_server_user_data"></a> [k3s\_server\_user\_data](#output\_k3s\_server\_user\_data) | k3s server user data |
| <a name="output_k3s_token"></a> [k3s\_token](#output\_k3s\_token) | Token generated for k3s |
| <a name="output_k3s_worker_user_data"></a> [k3s\_worker\_user\_data](#output\_k3s\_worker\_user\_data) | k3s worker user data |
