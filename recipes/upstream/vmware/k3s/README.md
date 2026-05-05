## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.10.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.23.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.4 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2 |
| <a name="requirement_rancher2"></a> [rancher2](#requirement\_rancher2) | >= 3.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.9.1 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4.0 |
| <a name="requirement_vsphere"></a> [vsphere](#requirement\_vsphere) | ~> 2.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | 2.6.1 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.4 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_k3s_additional"></a> [k3s\_additional](#module\_k3s\_additional) | ../../../../modules/distribution/k3s | n/a |
| <a name="module_k3s_additional_servers"></a> [k3s\_additional\_servers](#module\_k3s\_additional\_servers) | ../../../../modules/infra/vmware | n/a |
| <a name="module_k3s_first"></a> [k3s\_first](#module\_k3s\_first) | ../../../../modules/distribution/k3s | n/a |
| <a name="module_k3s_first_server"></a> [k3s\_first\_server](#module\_k3s\_first\_server) | ../../../../modules/infra/vmware | n/a |
| <a name="module_rancher_install"></a> [rancher\_install](#module\_rancher\_install) | ../../../../modules/rancher | n/a |

## Resources

| Name | Type |
|------|------|
| [local_file.private_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.public_key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.retrieve_kubeconfig](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.wait_for_cluster_ready](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.wait_for_k3s](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [tls_private_key.ssh_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cert_manager_helm_repository"></a> [cert\_manager\_helm\_repository](#input\_cert\_manager\_helm\_repository) | Cert-manager Helm repository URL | `string` | `"https://charts.jetstack.io"` | no |
| <a name="input_cert_manager_helm_repository_password"></a> [cert\_manager\_helm\_repository\_password](#input\_cert\_manager\_helm\_repository\_password) | Cert-manager Helm repository password | `string` | `null` | no |
| <a name="input_cert_manager_helm_repository_username"></a> [cert\_manager\_helm\_repository\_username](#input\_cert\_manager\_helm\_repository\_username) | Cert-manager Helm repository username | `string` | `null` | no |
| <a name="input_create_ssh_key_pair"></a> [create\_ssh\_key\_pair](#input\_create\_ssh\_key\_pair) | Create new SSH key pair (if true, ssh\_private\_key\_path is ignored) | `bool` | `true` | no |
| <a name="input_helm_timeout"></a> [helm\_timeout](#input\_helm\_timeout) | Timeout in seconds for Helm releases | `number` | `1800` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of K3s server nodes (use odd numbers: 1, 3, 5 for HA) | `number` | `3` | no |
| <a name="input_k3s_channel"></a> [k3s\_channel](#input\_k3s\_channel) | K3s channel to use (default: stable) | `string` | `"stable"` | no |
| <a name="input_k3s_config"></a> [k3s\_config](#input\_k3s\_config) | Additional K3s config.yaml content (YAML format) | `string` | `null` | no |
| <a name="input_k3s_ingress"></a> [k3s\_ingress](#input\_k3s\_ingress) | Ingress controller mapped to Rancher values (default traefik for K3s usually, but leaving flexibility if modified through k3s\_config) | `string` | `"traefik"` | no |
| <a name="input_k3s_token"></a> [k3s\_token](#input\_k3s\_token) | K3s cluster token (auto-generated if null) | `string` | `null` | no |
| <a name="input_k3s_version"></a> [k3s\_version](#input\_k3s\_version) | K3s version to use. Leave null for the latest in a channel. | `string` | `null` | no |
| <a name="input_kube_config_path"></a> [kube\_config\_path](#input\_kube\_config\_path) | Path to save kubeconfig file | `string` | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix for resource naming | `string` | n/a | yes |
| <a name="input_rancher_bootstrap_password"></a> [rancher\_bootstrap\_password](#input\_rancher\_bootstrap\_password) | Rancher initial bootstrap password (used for first-time login) | `string` | `"initial-bootstrap-password"` | no |
| <a name="input_rancher_helm_repository"></a> [rancher\_helm\_repository](#input\_rancher\_helm\_repository) | Rancher Helm repository URL | `string` | `"https://releases.rancher.com/server-charts/stable"` | no |
| <a name="input_rancher_helm_repository_password"></a> [rancher\_helm\_repository\_password](#input\_rancher\_helm\_repository\_password) | Rancher Helm repository password | `string` | `null` | no |
| <a name="input_rancher_helm_repository_username"></a> [rancher\_helm\_repository\_username](#input\_rancher\_helm\_repository\_username) | Rancher Helm repository username | `string` | `null` | no |
| <a name="input_rancher_password"></a> [rancher\_password](#input\_rancher\_password) | Rancher permanent admin password (set after bootstrap) | `string` | `"admin"` | no |
| <a name="input_rancher_replicas"></a> [rancher\_replicas](#input\_rancher\_replicas) | Number of Rancher replicas | `number` | `3` | no |
| <a name="input_rancher_version"></a> [rancher\_version](#input\_rancher\_version) | Rancher version to install | `string` | `"v2.13.1"` | no |
| <a name="input_ssh_private_key_path"></a> [ssh\_private\_key\_path](#input\_ssh\_private\_key\_path) | Path to SSH private key (required if create\_ssh\_key\_pair is false) | `string` | `null` | no |
| <a name="input_ssh_public_key_path"></a> [ssh\_public\_key\_path](#input\_ssh\_public\_key\_path) | Path to SSH public key for VM access | `string` | `null` | no |
| <a name="input_start_index"></a> [start\_index](#input\_start\_index) | Starting index for server nodes | `number` | `1` | no |
| <a name="input_vm_cpus"></a> [vm\_cpus](#input\_vm\_cpus) | Number of vCPUs per VM | `number` | `4` | no |
| <a name="input_vm_disk"></a> [vm\_disk](#input\_vm\_disk) | Disk size in GB | `number` | `100` | no |
| <a name="input_vm_memory"></a> [vm\_memory](#input\_vm\_memory) | Memory in MB per VM | `number` | `8192` | no |
| <a name="input_vm_username"></a> [vm\_username](#input\_vm\_username) | SSH username for VM access | `string` | `"ubuntu"` | no |
| <a name="input_vsphere_allow_unverified_ssl"></a> [vsphere\_allow\_unverified\_ssl](#input\_vsphere\_allow\_unverified\_ssl) | Allow unverified SSL certificates | `bool` | `true` | no |
| <a name="input_vsphere_cluster"></a> [vsphere\_cluster](#input\_vsphere\_cluster) | vSphere compute cluster name (cluster-based setup) | `string` | `null` | no |
| <a name="input_vsphere_datacenter"></a> [vsphere\_datacenter](#input\_vsphere\_datacenter) | vSphere datacenter name | `string` | n/a | yes |
| <a name="input_vsphere_datastore"></a> [vsphere\_datastore](#input\_vsphere\_datastore) | vSphere datastore for VM storage | `string` | n/a | yes |
| <a name="input_vsphere_folder"></a> [vsphere\_folder](#input\_vsphere\_folder) | vSphere folder for VM placement (optional) | `string` | `null` | no |
| <a name="input_vsphere_host"></a> [vsphere\_host](#input\_vsphere\_host) | vSphere ESXi host FQDN or IP (standalone host setup) | `string` | `null` | no |
| <a name="input_vsphere_network"></a> [vsphere\_network](#input\_vsphere\_network) | vSphere network name | `string` | n/a | yes |
| <a name="input_vsphere_password"></a> [vsphere\_password](#input\_vsphere\_password) | vSphere password | `string` | n/a | yes |
| <a name="input_vsphere_resource_pool"></a> [vsphere\_resource\_pool](#input\_vsphere\_resource\_pool) | vSphere resource pool (alternative to cluster/host - full path) | `string` | `null` | no |
| <a name="input_vsphere_server"></a> [vsphere\_server](#input\_vsphere\_server) | vSphere server hostname or IP | `string` | n/a | yes |
| <a name="input_vsphere_user"></a> [vsphere\_user](#input\_vsphere\_user) | vSphere username | `string` | n/a | yes |
| <a name="input_vsphere_virtual_machine"></a> [vsphere\_virtual\_machine](#input\_vsphere\_virtual\_machine) | VM template name (must have cloud-init and VMware guestinfo support) | `string` | n/a | yes |
| <a name="input_wait"></a> [wait](#input\_wait) | Wait before installing Rancher (seconds) | `number` | `60` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_additional_servers_ips"></a> [additional\_servers\_ips](#output\_additional\_servers\_ips) | The IP addresses of additional K3s servers. |
| <a name="output_first_server_ip"></a> [first\_server\_ip](#output\_first\_server\_ip) | The IP address of the first K3s server. |
| <a name="output_first_server_ssh_key_path"></a> [first\_server\_ssh\_key\_path](#output\_first\_server\_ssh\_key\_path) | Path to the SSH private key for the first K3s server. |
| <a name="output_kube_config_path"></a> [kube\_config\_path](#output\_kube\_config\_path) | The path pointing to the locally retrieved kubeconfig file. |
| <a name="output_rancher_bootstrap_password"></a> [rancher\_bootstrap\_password](#output\_rancher\_bootstrap\_password) | Rancher initial Bootstrap Password. |
| <a name="output_rancher_password"></a> [rancher\_password](#output\_rancher\_password) | Rancher Admin Password. |
| <a name="output_rancher_url"></a> [rancher\_url](#output\_rancher\_url) | The Rancher URL. |
