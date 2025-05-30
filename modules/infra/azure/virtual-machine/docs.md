## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_security_group_association.nsg_assoc](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_security_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.allow_inbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.allow_outbound](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_public_ip.vm_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [local_file.private_key_pem](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.public_key_pem](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [tls_private_key.ssh_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [local_file.private_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |
| [local_file.public_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_firewall"></a> [create\_firewall](#input\_create\_firewall) | Azure Network security rule used for all resources | `bool` | `true` | no |
| <a name="input_create_rg"></a> [create\_rg](#input\_create\_rg) | Specify if resource group needs to be created | `bool` | `true` | no |
| <a name="input_create_ssh_key_pair"></a> [create\_ssh\_key\_pair](#input\_create\_ssh\_key\_pair) | Specify if a new SSH key pair needs to be created for the instances | `bool` | `true` | no |
| <a name="input_create_subnet"></a> [create\_subnet](#input\_create\_subnet) | Specifies whether a Virtual Subnet should be created for the instances. Default is 'true'. | `bool` | `true` | no |
| <a name="input_create_vnet"></a> [create\_vnet](#input\_create\_vnet) | Specifies whether a Virtual Network should be created for the instances. Default is 'true'. | `bool` | `true` | no |
| <a name="input_disk_type"></a> [disk\_type](#input\_disk\_type) | Specifies the type of the disks attached to each node ('Standard\_LRS, 'StandardSSD\_LRS', 'Premium\_LRS' or 'UltraSSD\_LRS'). Default is 'Premium\_LRS'. | `string` | `"Standard_LRS"` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | The number of nodes | `number` | `3` | no |
| <a name="input_instance_disk_size"></a> [instance\_disk\_size](#input\_instance\_disk\_size) | Size of the disk attached to each node, specified in GB | `number` | `50` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The name of a Virtual Machine instance type | `string` | `"Standard_D2_v5"` | no |
| <a name="input_ip_cidr_range"></a> [ip\_cidr\_range](#input\_ip\_cidr\_range) | Range of private IPs available for the Azure Subnet | `string` | `"10.10.0.0/24"` | no |
| <a name="input_network_security_group_id"></a> [network\_security\_group\_id](#input\_network\_security\_group\_id) | Azure Network Security group id required to attach NIC to | `string` | `null` | no |
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | Operating system type (sles or ubuntu) | `string` | `"sles"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix used in front of all Azure resources | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Specifies the Azure region used for all resources. Default is 'westeurope'. | `string` | `"westeurope"` | no |
| <a name="input_resource_group_location"></a> [resource\_group\_location](#input\_resource\_group\_location) | Specify location of resource group | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Specify name of resource group | `string` | `null` | no |
| <a name="input_spot_instance"></a> [spot\_instance](#input\_spot\_instance) | Specify if Spot instances feature is enabled on Azure Virtual Machines | `bool` | `true` | no |
| <a name="input_ssh_private_key_path"></a> [ssh\_private\_key\_path](#input\_ssh\_private\_key\_path) | The full path where is present the pre-generated SSH PRIVATE key (not generated by Terraform) | `string` | `null` | no |
| <a name="input_ssh_public_key_path"></a> [ssh\_public\_key\_path](#input\_ssh\_public\_key\_path) | The full path where is present the pre-generated SSH PUBLIC key (not generated by Terraform) | `string` | `null` | no |
| <a name="input_startup_script"></a> [startup\_script](#input\_startup\_script) | Custom startup script | `string` | `null` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Azure subnet id from inside Azure vnet | `string` | `null` | no |
| <a name="input_tag_begin"></a> [tag\_begin](#input\_tag\_begin) | tag number added to Azure Virtual Machine | `string` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_firewall_inbound"></a> [firewall\_inbound](#output\_firewall\_inbound) | n/a |
| <a name="output_firewall_outbound"></a> [firewall\_outbound](#output\_firewall\_outbound) | n/a |
| <a name="output_instance_ips"></a> [instance\_ips](#output\_instance\_ips) | n/a |
| <a name="output_instances_private_ip"></a> [instances\_private\_ip](#output\_instances\_private\_ip) | Azure Virtual Machines Private IPs |
| <a name="output_instances_public_ip"></a> [instances\_public\_ip](#output\_instances\_public\_ip) | Azure Virtual Machines Public IPs |
| <a name="output_network_security_group_id"></a> [network\_security\_group\_id](#output\_network\_security\_group\_id) | n/a |
| <a name="output_public_ssh_key"></a> [public\_ssh\_key](#output\_public\_ssh\_key) | n/a |
| <a name="output_resource_group_location"></a> [resource\_group\_location](#output\_resource\_group\_location) | n/a |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | n/a |
| <a name="output_subnet"></a> [subnet](#output\_subnet) | n/a |
| <a name="output_vnet"></a> [vnet](#output\_vnet) | n/a |
