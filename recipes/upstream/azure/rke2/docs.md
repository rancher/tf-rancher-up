## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.27.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.10.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0.0 |
| <a name="requirement_ssh"></a> [ssh](#requirement\_ssh) | 2.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | 2.5.3 |
| <a name="provider_ssh"></a> [ssh](#provider\_ssh) | 2.6.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rancher_install"></a> [rancher\_install](#module\_rancher\_install) | ../../../../modules/rancher | n/a |
| <a name="module_rke2_additional"></a> [rke2\_additional](#module\_rke2\_additional) | ../../../../modules/distribution/rke2 | n/a |
| <a name="module_rke2_additional_servers"></a> [rke2\_additional\_servers](#module\_rke2\_additional\_servers) | ../../../../modules/infra/azure/virtual-machine | n/a |
| <a name="module_rke2_first"></a> [rke2\_first](#module\_rke2\_first) | ../../../../modules/distribution/rke2 | n/a |
| <a name="module_rke2_first_server"></a> [rke2\_first\_server](#module\_rke2\_first\_server) | ../../../../modules/infra/azure/virtual-machine | n/a |

## Resources

| Name | Type |
|------|------|
| [local_file.kube_config_yaml](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [ssh_resource.retrieve_kubeconfig](https://registry.terraform.io/providers/loafoe/ssh/2.6.0/docs/resources/resource) | resource |
| [local_file.ssh_private_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bootstrap_rancher"></a> [bootstrap\_rancher](#input\_bootstrap\_rancher) | Bootstrap the Rancher installation | `bool` | `true` | no |
| <a name="input_create_firewall"></a> [create\_firewall](#input\_create\_firewall) | Azure Network security rule used for all resources | `bool` | `true` | no |
| <a name="input_create_rg"></a> [create\_rg](#input\_create\_rg) | Specify if resource group needs to be created | `bool` | `true` | no |
| <a name="input_create_ssh_key_pair"></a> [create\_ssh\_key\_pair](#input\_create\_ssh\_key\_pair) | Specify if a new SSH key pair needs to be created for the instances | `bool` | `true` | no |
| <a name="input_create_subnet"></a> [create\_subnet](#input\_create\_subnet) | Specifies whether a Virtual Subnet should be created for the instances. Default is 'true'. | `bool` | `true` | no |
| <a name="input_create_vnet"></a> [create\_vnet](#input\_create\_vnet) | Specifies whether a Virtual Network should be created for the instances. Default is 'true'. | `bool` | `true` | no |
| <a name="input_disk_type"></a> [disk\_type](#input\_disk\_type) | Specifies the type of the disks attached to each node ('Standard\_LRS, 'StandardSSD\_LRS', 'Premium\_LRS' or 'UltraSSD\_LRS'). Default is 'Premium\_LRS'. | `string` | `"Standard_LRS"` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | The number of nodes | `number` | `3` | no |
| <a name="input_instance_disk_size"></a> [instance\_disk\_size](#input\_instance\_disk\_size) | Size of the disk attached to each node, specified in GB | `number` | `50` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The name of a Virtual Machine instance type | `string` | `"Standard_D2_v5"` | no |
| <a name="input_kube_config_filename"></a> [kube\_config\_filename](#input\_kube\_config\_filename) | Filename to write the kube config | `string` | `null` | no |
| <a name="input_kube_config_path"></a> [kube\_config\_path](#input\_kube\_config\_path) | The path to write the kubeconfig for the RKE cluster | `string` | `null` | no |
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | Operating system type (sles or ubuntu) | `string` | `"sles"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix used in front of all Azure resources | `string` | n/a | yes |
| <a name="input_rancher_bootstrap_password"></a> [rancher\_bootstrap\_password](#input\_rancher\_bootstrap\_password) | Password to use when bootstrapping Rancher (min 12 characters) | `string` | `"initial-bootstrap-password"` | no |
| <a name="input_rancher_hostname"></a> [rancher\_hostname](#input\_rancher\_hostname) | Hostname to set when installing Rancher | `string` | `"rancher"` | no |
| <a name="input_rancher_ingress_class_name"></a> [rancher\_ingress\_class\_name](#input\_rancher\_ingress\_class\_name) | Rancher ingressClassName value | `string` | `"nginx"` | no |
| <a name="input_rancher_password"></a> [rancher\_password](#input\_rancher\_password) | Password for the Rancher admin account (min 12 characters) | `string` | `null` | no |
| <a name="input_rancher_service_type"></a> [rancher\_service\_type](#input\_rancher\_service\_type) | Rancher serviceType value | `string` | `"ClusterIP"` | no |
| <a name="input_rancher_version"></a> [rancher\_version](#input\_rancher\_version) | Rancher version to install | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | Specifies the Azure region used for all resources. Default is 'westeurope'. | `string` | `"westeurope"` | no |
| <a name="input_rke2_config"></a> [rke2\_config](#input\_rke2\_config) | Additional RKE2 configuration to add to the config.yaml file | `string` | `null` | no |
| <a name="input_rke2_token"></a> [rke2\_token](#input\_rke2\_token) | Token to use when configuring RKE2 nodes | `string` | `null` | no |
| <a name="input_rke2_version"></a> [rke2\_version](#input\_rke2\_version) | Kubernetes version to use for the RKE2 cluster | `string` | `null` | no |
| <a name="input_spot_instance"></a> [spot\_instance](#input\_spot\_instance) | Specify if Spot instances feature is enabled on Azure Virtual Machines | `bool` | `true` | no |
| <a name="input_ssh_private_key_path"></a> [ssh\_private\_key\_path](#input\_ssh\_private\_key\_path) | The full path where is present the pre-generated SSH PRIVATE key (not generated by Terraform) | `string` | `null` | no |
| <a name="input_ssh_public_key_path"></a> [ssh\_public\_key\_path](#input\_ssh\_public\_key\_path) | The full path where is present the pre-generated SSH PUBLIC key (not generated by Terraform) | `string` | `null` | no |
| <a name="input_startup_script"></a> [startup\_script](#input\_startup\_script) | Custom startup script | `string` | `null` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Specifies the Azure Subscription ID that will contain all created resources. Default is 'azure-tf'. | `string` | `"azure-tf"` | no |
| <a name="input_tag_begin"></a> [tag\_begin](#input\_tag\_begin) | tag number added to DigitalOcean droplet | `string` | `2` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instances_private_ip"></a> [instances\_private\_ip](#output\_instances\_private\_ip) | n/a |
| <a name="output_instances_public_ip"></a> [instances\_public\_ip](#output\_instances\_public\_ip) | n/a |
| <a name="output_instances_ssh_username"></a> [instances\_ssh\_username](#output\_instances\_ssh\_username) | Username used for SSH login |
| <a name="output_rancher_password"></a> [rancher\_password](#output\_rancher\_password) | Rancher Initial Custom Password |
| <a name="output_rancher_url"></a> [rancher\_url](#output\_rancher\_url) | Rancher URL |
