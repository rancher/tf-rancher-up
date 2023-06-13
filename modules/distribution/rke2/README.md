## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_vsphere"></a> [vsphere](#requirement\_vsphere) | 2.0.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_external"></a> [external](#provider\_external) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [local_file.script_kubeconfig](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.deploy_rancher](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.rke2_common](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.rke2_server1_provisioning](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.rke2_servers_others_provisioning](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.rke2_workers_provisioning](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [time_sleep.sleep_between_first_server_and_others](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [external_external.kubeconfig](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |
| [template_file.config_other_yaml](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.config_server_yaml](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.rancher_manifest](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cp_vm_count"></a> [cp\_vm\_count](#input\_cp\_vm\_count) | Number of VMs to spin up for RKE | `any` | n/a | yes |
| <a name="input_do_deploy_rancher"></a> [do\_deploy\_rancher](#input\_do\_deploy\_rancher) | Variable to decide if Rancher will be deployed. | `bool` | `false` | no |
| <a name="input_public_key_path"></a> [public\_key\_path](#input\_public\_key\_path) | path of public key for nodes | `string` | `"~/.ssh/id_rsa.pub"` | no |
| <a name="input_rancher_hostname"></a> [rancher\_hostname](#input\_rancher\_hostname) | Desired Hostname for Rancher App | `string` | `""` | no |
| <a name="input_rke2_token"></a> [rke2\_token](#input\_rke2\_token) | Desired RKE2 token | `any` | n/a | yes |
| <a name="input_ssh_password"></a> [ssh\_password](#input\_ssh\_password) | SSH Password to connect to VM with | `string` | n/a | yes |
| <a name="input_ssh_user"></a> [ssh\_user](#input\_ssh\_user) | SSH Username to connect to VM with | `string` | n/a | yes |
| <a name="input_vm_ips"></a> [vm\_ips](#input\_vm\_ips) | List of IP Addresses for all VMs to use deploy Rancher on. | `list(string)` | n/a | yes |
| <a name="input_vm_name_prefix"></a> [vm\_name\_prefix](#input\_vm\_name\_prefix) | Prefix for the VM name in vSphere | `string` | `"rancher-ha"` | no |
| <a name="input_wk_vm_count"></a> [wk\_vm\_count](#input\_wk\_vm\_count) | Number of VMs to spin up for RKE | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kubeconfig"></a> [kubeconfig](#output\_kubeconfig) | n/a |
