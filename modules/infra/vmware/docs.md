## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |
| <a name="provider_vsphere"></a> [vsphere](#provider\_vsphere) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [local_file.private_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [tls_private_key.ssh_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [vsphere_virtual_machine.instance](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/resources/virtual_machine) | resource |
| [vsphere_compute_cluster.cluster](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/compute_cluster) | data source |
| [vsphere_datacenter.dc](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/datacenter) | data source |
| [vsphere_datastore.datastore](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/datastore) | data source |
| [vsphere_folder.folder](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/folder) | data source |
| [vsphere_host.host](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/host) | data source |
| [vsphere_network.network](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/network) | data source |
| [vsphere_resource_pool.pool](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/resource_pool) | data source |
| [vsphere_virtual_machine.template](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/virtual_machine) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_ssh_key_pair"></a> [create\_ssh\_key\_pair](#input\_create\_ssh\_key\_pair) | Create new SSH key pair | `bool` | `false` | no |
| <a name="input_dependency"></a> [dependency](#input\_dependency) | Optional dependency from another resource | `any` | `null` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of VMs to create | `number` | `1` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix for VM naming | `string` | n/a | yes |
| <a name="input_ssh_private_key"></a> [ssh\_private\_key](#input\_ssh\_private\_key) | SSH private key content (takes precedence over ssh\_private\_key\_path) | `string` | `null` | no |
| <a name="input_ssh_private_key_path"></a> [ssh\_private\_key\_path](#input\_ssh\_private\_key\_path) | Path to SSH private key (used if ssh\_private\_key is not provided) | `string` | `null` | no |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | SSH public key for VM access | `string` | n/a | yes |
| <a name="input_start_index"></a> [start\_index](#input\_start\_index) | Starting index for VM naming (e.g., 1 for cp-1, 2 for cp-2) | `number` | `1` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | Cloud-init user data (YAML). If null, uses default template. | `string` | `null` | no |
| <a name="input_vm_cpus"></a> [vm\_cpus](#input\_vm\_cpus) | Number of vCPUs per VM | `number` | `4` | no |
| <a name="input_vm_disk"></a> [vm\_disk](#input\_vm\_disk) | Disk size in GB | `number` | `100` | no |
| <a name="input_vm_memory"></a> [vm\_memory](#input\_vm\_memory) | Memory in MB per VM | `number` | `8192` | no |
| <a name="input_vm_username"></a> [vm\_username](#input\_vm\_username) | SSH username for VM access | `string` | `"ubuntu"` | no |
| <a name="input_vsphere_allow_unverified_ssl"></a> [vsphere\_allow\_unverified\_ssl](#input\_vsphere\_allow\_unverified\_ssl) | Allow unverified SSL certificates | `bool` | `true` | no |
| <a name="input_vsphere_cluster"></a> [vsphere\_cluster](#input\_vsphere\_cluster) | vSphere compute cluster name (uses default resource pool). Specify one: cluster, host, or resource\_pool. | `string` | `null` | no |
| <a name="input_vsphere_datacenter"></a> [vsphere\_datacenter](#input\_vsphere\_datacenter) | vSphere datacenter name | `string` | n/a | yes |
| <a name="input_vsphere_datastore"></a> [vsphere\_datastore](#input\_vsphere\_datastore) | vSphere datastore for VM storage | `string` | n/a | yes |
| <a name="input_vsphere_firmware"></a> [vsphere\_firmware](#input\_vsphere\_firmware) | Firmware for the VM (bios or efi). Defaults to template value if null. | `string` | `null` | no |
| <a name="input_vsphere_folder"></a> [vsphere\_folder](#input\_vsphere\_folder) | vSphere folder for VM placement (e.g., 'my-folder' or 'parent/child-folder'). Optional. | `string` | `null` | no |
| <a name="input_vsphere_host"></a> [vsphere\_host](#input\_vsphere\_host) | vSphere ESXi host (standalone host setup). Specify one: cluster, host, or resource\_pool. | `string` | `null` | no |
| <a name="input_vsphere_network"></a> [vsphere\_network](#input\_vsphere\_network) | vSphere network name | `string` | n/a | yes |
| <a name="input_vsphere_password"></a> [vsphere\_password](#input\_vsphere\_password) | vSphere password | `string` | n/a | yes |
| <a name="input_vsphere_resource_pool"></a> [vsphere\_resource\_pool](#input\_vsphere\_resource\_pool) | vSphere resource pool (full path like 'cluster1/Resources/mypool'). Specify one: cluster, host, or resource\_pool. | `string` | `null` | no |
| <a name="input_vsphere_server"></a> [vsphere\_server](#input\_vsphere\_server) | vSphere server hostname or IP | `string` | n/a | yes |
| <a name="input_vsphere_user"></a> [vsphere\_user](#input\_vsphere\_user) | vSphere username | `string` | n/a | yes |
| <a name="input_vsphere_virtual_machine"></a> [vsphere\_virtual\_machine](#input\_vsphere\_virtual\_machine) | VM template name (must have cloud-init support) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dependency"></a> [dependency](#output\_dependency) | Dependency output for chaining resources |
| <a name="output_instances_private_ip"></a> [instances\_private\_ip](#output\_instances\_private\_ip) | Private IP addresses of VMs |
| <a name="output_instances_public_ip"></a> [instances\_public\_ip](#output\_instances\_public\_ip) | Public IP addresses of VMs (same as private for on-prem) |
| <a name="output_ssh_key_path"></a> [ssh\_key\_path](#output\_ssh\_key\_path) | Path to SSH private key |
| <a name="output_ssh_public_key"></a> [ssh\_public\_key](#output\_ssh\_public\_key) | SSH public key used for VMs |
| <a name="output_vm_ids"></a> [vm\_ids](#output\_vm\_ids) | VM instance IDs |
