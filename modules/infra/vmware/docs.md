## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vsphere"></a> [vsphere](#provider\_vsphere) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [vsphere_virtual_machine.instance](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/resources/virtual_machine) | resource |
| [vsphere_datacenter.dc](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/datacenter) | data source |
| [vsphere_datastore.datastore](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/datastore) | data source |
| [vsphere_network.network](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/network) | data source |
| [vsphere_resource_pool.pool](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/resource_pool) | data source |
| [vsphere_virtual_machine.template](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/virtual_machine) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorized_keys"></a> [authorized\_keys](#input\_authorized\_keys) | Add in your SSH public key. This will be added to the VMs by cloud-init in the authorized\_keys file under ~/.ssh | `any` | n/a | yes |
| <a name="input_docker_version"></a> [docker\_version](#input\_docker\_version) | n/a | `string` | `"20.10"` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of instances to create | `number` | `3` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix to use for various resources | `any` | n/a | yes |
| <a name="input_ssh_private_key_path"></a> [ssh\_private\_key\_path](#input\_ssh\_private\_key\_path) | Add your Private Key | `any` | n/a | yes |
| <a name="input_vm_cpus"></a> [vm\_cpus](#input\_vm\_cpus) | n/a | `number` | `2` | no |
| <a name="input_vm_disk"></a> [vm\_disk](#input\_vm\_disk) | n/a | `number` | `80` | no |
| <a name="input_vm_memory"></a> [vm\_memory](#input\_vm\_memory) | n/a | `number` | `4096` | no |
| <a name="input_vm_username"></a> [vm\_username](#input\_vm\_username) | n/a | `any` | n/a | yes |
| <a name="input_vsphere_datacenter"></a> [vsphere\_datacenter](#input\_vsphere\_datacenter) | vSphere Datacenter details. | `any` | n/a | yes |
| <a name="input_vsphere_datastore"></a> [vsphere\_datastore](#input\_vsphere\_datastore) | Datastore used for storing VM data. | `any` | n/a | yes |
| <a name="input_vsphere_network"></a> [vsphere\_network](#input\_vsphere\_network) | n/a | `any` | n/a | yes |
| <a name="input_vsphere_password"></a> [vsphere\_password](#input\_vsphere\_password) | Add your vSphere password for the above mentioned username. | `string` | n/a | yes |
| <a name="input_vsphere_resource_pool"></a> [vsphere\_resource\_pool](#input\_vsphere\_resource\_pool) | Available resourcepool on the host. | `any` | n/a | yes |
| <a name="input_vsphere_server"></a> [vsphere\_server](#input\_vsphere\_server) | Add the vSphere hostname. | `any` | n/a | yes |
| <a name="input_vsphere_server_allow_unverified_ssl"></a> [vsphere\_server\_allow\_unverified\_ssl](#input\_vsphere\_server\_allow\_unverified\_ssl) | Allow use of unverified SSL certificates (Ex: Self signed) | `any` | n/a | yes |
| <a name="input_vsphere_user"></a> [vsphere\_user](#input\_vsphere\_user) | Add your vSphere username. | `string` | n/a | yes |
| <a name="input_vsphere_virtual_machine"></a> [vsphere\_virtual\_machine](#input\_vsphere\_virtual\_machine) | Virtual Machine template name | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rancher_ip"></a> [rancher\_ip](#output\_rancher\_ip) | This output will get IP from the first VM on which Rancher will be installed. |
| <a name="output_vsphere_virtual_machine"></a> [vsphere\_virtual\_machine](#output\_vsphere\_virtual\_machine) | VM IPs |
