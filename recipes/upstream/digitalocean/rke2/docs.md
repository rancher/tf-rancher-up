## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | >= 2.30.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 3.0.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.23.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.1.0 |
| <a name="requirement_ssh"></a> [ssh](#requirement\_ssh) | >= 2.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | 2.101.1 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.9.1 |
| <a name="provider_ssh"></a> [ssh](#provider\_ssh) | 2.7.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rancher_install"></a> [rancher\_install](#module\_rancher\_install) | ../../../../modules/rancher | n/a |
| <a name="module_rke2_additional"></a> [rke2\_additional](#module\_rke2\_additional) | ../../../../modules/distribution/rke2 | n/a |
| <a name="module_rke2_additional_servers"></a> [rke2\_additional\_servers](#module\_rke2\_additional\_servers) | ../../../../modules/infra/digitalocean/ | n/a |
| <a name="module_rke2_first"></a> [rke2\_first](#module\_rke2\_first) | ../../../../modules/distribution/rke2 | n/a |
| <a name="module_rke2_first_server"></a> [rke2\_first\_server](#module\_rke2\_first\_server) | ../../../../modules/infra/digitalocean/ | n/a |

## Resources

| Name | Type |
|------|------|
| [digitalocean_vpc.cluster](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/vpc) | resource |
| [local_sensitive_file.kube_config_yaml](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file) | resource |
| [ssh_resource.canal_private_interface](https://registry.terraform.io/providers/loafoe/ssh/latest/docs/resources/resource) | resource |
| [ssh_resource.retrieve_kubeconfig](https://registry.terraform.io/providers/loafoe/ssh/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bootstrap_rancher"></a> [bootstrap\_rancher](#input\_bootstrap\_rancher) | Bootstrap the Rancher installation | `bool` | `true` | no |
| <a name="input_cert_manager_helm_repository"></a> [cert\_manager\_helm\_repository](#input\_cert\_manager\_helm\_repository) | Helm repository for Cert Manager chart | `string` | `null` | no |
| <a name="input_cert_manager_helm_repository_password"></a> [cert\_manager\_helm\_repository\_password](#input\_cert\_manager\_helm\_repository\_password) | Private Cert Manager helm repository password | `string` | `null` | no |
| <a name="input_cert_manager_helm_repository_username"></a> [cert\_manager\_helm\_repository\_username](#input\_cert\_manager\_helm\_repository\_username) | Private Cert Manager helm repository username | `string` | `null` | no |
| <a name="input_create_firewall"></a> [create\_firewall](#input\_create\_firewall) | Specify if a firewall to access droplets needs to be created for the instances | `bool` | `true` | no |
| <a name="input_create_https_loadbalancer"></a> [create\_https\_loadbalancer](#input\_create\_https\_loadbalancer) | Specify if a loadbalancer for port 443 needs to be created for the instances | `bool` | `false` | no |
| <a name="input_create_k8s_api_loadbalancer"></a> [create\_k8s\_api\_loadbalancer](#input\_create\_k8s\_api\_loadbalancer) | Specify if a loadbalancer for port 6443 needs to be created for the instances | `bool` | `false` | no |
| <a name="input_create_ssh_key_pair"></a> [create\_ssh\_key\_pair](#input\_create\_ssh\_key\_pair) | Specify if a new SSH key pair needs to be created for the instances | `bool` | `true` | no |
| <a name="input_do_token"></a> [do\_token](#input\_do\_token) | DigitalOcean Authentication Token | `string` | n/a | yes |
| <a name="input_droplet_count"></a> [droplet\_count](#input\_droplet\_count) | Number of droplets to create. Every node runs etcd, so use 1 or an odd number (3, 5) for HA | `number` | `3` | no |
| <a name="input_droplet_image"></a> [droplet\_image](#input\_droplet\_image) | name of the OpenSUSE custom image uploaded to DigitalOcean account | `string` | `"openSUSE-Leap-15.6"` | no |
| <a name="input_droplet_size"></a> [droplet\_size](#input\_droplet\_size) | Size used for all droplets | `string` | `"s-2vcpu-4gb"` | no |
| <a name="input_kube_audit_level"></a> [kube\_audit\_level](#input\_kube\_audit\_level) | Kubernetes API audit level for the Rancher (local) cluster: None (disabled), Metadata (who, what, when), Request (+ request bodies) or RequestResponse (+ response bodies). Secrets, ConfigMaps and token reviews are always capped at Metadata. Changing it rebuilds the nodes (it is applied through user\_data) | `string` | `"None"` | no |
| <a name="input_kube_audit_log_max_age"></a> [kube\_audit\_log\_max\_age](#input\_kube\_audit\_log\_max\_age) | Days to keep rotated Kubernetes audit log files | `number` | `30` | no |
| <a name="input_kube_audit_log_max_backup"></a> [kube\_audit\_log\_max\_backup](#input\_kube\_audit\_log\_max\_backup) | Number of rotated Kubernetes audit log files to keep | `number` | `10` | no |
| <a name="input_kube_audit_log_max_size"></a> [kube\_audit\_log\_max\_size](#input\_kube\_audit\_log\_max\_size) | Size in MB at which the Kubernetes audit log file is rotated | `number` | `100` | no |
| <a name="input_kube_audit_policy"></a> [kube\_audit\_policy](#input\_kube\_audit\_policy) | Full Kubernetes audit Policy YAML to use instead of the one generated from kube\_audit\_level | `string` | `null` | no |
| <a name="input_kube_config_filename"></a> [kube\_config\_filename](#input\_kube\_config\_filename) | Filename to write the kube config | `string` | `null` | no |
| <a name="input_kube_config_path"></a> [kube\_config\_path](#input\_kube\_config\_path) | The path to write the kubeconfig for the RKE cluster | `string` | `null` | no |
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | Operating system type (opensuse or ubuntu) | `string` | `"opensuse"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix added to names of all resources. Must be unique in the DigitalOcean account (VPC names are account-wide) and a valid DNS label, as it becomes part of the Kubernetes node names | `string` | `"rancher-terraform"` | no |
| <a name="input_private_network_interface"></a> [private\_network\_interface](#input\_private\_network\_interface) | Droplet interface attached to the VPC; Canal's overlay network is pinned to it | `string` | `"eth1"` | no |
| <a name="input_rancher_additional_helm_values"></a> [rancher\_additional\_helm\_values](#input\_rancher\_additional\_helm\_values) | Extra Rancher helm values, one "key: value" string each (e.g. "auditLog.level: 1") | `list(string)` | `[]` | no |
| <a name="input_rancher_audit_log_destination"></a> [rancher\_audit\_log\_destination](#input\_rancher\_audit\_log\_destination) | Where Rancher writes the audit log: "sidecar" (read with kubectl logs, container rancher-audit-log) or "hostPath" (files under rancher\_audit\_log\_host\_path on each node running Rancher) | `string` | `"sidecar"` | no |
| <a name="input_rancher_audit_log_host_path"></a> [rancher\_audit\_log\_host\_path](#input\_rancher\_audit\_log\_host\_path) | Node directory for the audit log files when rancher\_audit\_log\_destination is "hostPath" | `string` | `"/var/log/rancher/audit"` | no |
| <a name="input_rancher_audit_log_level"></a> [rancher\_audit\_log\_level](#input\_rancher\_audit\_log\_level) | Rancher API audit log level: 0 = disabled, 1 = metadata (who, what, when), 2 = 1 + request bodies, 3 = 2 + response bodies | `number` | `0` | no |
| <a name="input_rancher_audit_log_max_age"></a> [rancher\_audit\_log\_max\_age](#input\_rancher\_audit\_log\_max\_age) | Days to keep rotated audit log files (chart default when null) | `number` | `null` | no |
| <a name="input_rancher_audit_log_max_backup"></a> [rancher\_audit\_log\_max\_backup](#input\_rancher\_audit\_log\_max\_backup) | Number of rotated audit log files to keep (chart default when null) | `number` | `null` | no |
| <a name="input_rancher_audit_log_max_size"></a> [rancher\_audit\_log\_max\_size](#input\_rancher\_audit\_log\_max\_size) | Size in MB at which the audit log file is rotated (chart default when null) | `number` | `null` | no |
| <a name="input_rancher_bootstrap_password"></a> [rancher\_bootstrap\_password](#input\_rancher\_bootstrap\_password) | Password to use when bootstrapping Rancher (min 12 characters) | `string` | `"initial-bootstrap-password"` | no |
| <a name="input_rancher_helm_repository"></a> [rancher\_helm\_repository](#input\_rancher\_helm\_repository) | Helm repository for Rancher chart | `string` | `null` | no |
| <a name="input_rancher_helm_repository_password"></a> [rancher\_helm\_repository\_password](#input\_rancher\_helm\_repository\_password) | Private Rancher helm repository password | `string` | `null` | no |
| <a name="input_rancher_helm_repository_username"></a> [rancher\_helm\_repository\_username](#input\_rancher\_helm\_repository\_username) | Private Rancher helm repository username | `string` | `null` | no |
| <a name="input_rancher_hostname"></a> [rancher\_hostname](#input\_rancher\_hostname) | Hostname prefix for Rancher; the full hostname is <rancher\_hostname>.<first node public IP>.sslip.io | `string` | `"rancher"` | no |
| <a name="input_rancher_ingress_class_name"></a> [rancher\_ingress\_class\_name](#input\_rancher\_ingress\_class\_name) | Rancher ingressClassName value. Defaults to the class of the ingress selected by rke2\_ingress | `string` | `null` | no |
| <a name="input_rancher_password"></a> [rancher\_password](#input\_rancher\_password) | Password for the Rancher admin account (min 12 characters) | `string` | n/a | yes |
| <a name="input_rancher_replicas"></a> [rancher\_replicas](#input\_rancher\_replicas) | Value for replicas when installing the Rancher helm chart | `number` | `3` | no |
| <a name="input_rancher_service_type"></a> [rancher\_service\_type](#input\_rancher\_service\_type) | Rancher serviceType value | `string` | `"ClusterIP"` | no |
| <a name="input_rancher_version"></a> [rancher\_version](#input\_rancher\_version) | Rancher version to install | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | Region that droplets will be deployed to | `string` | `"sfo3"` | no |
| <a name="input_rke2_config"></a> [rke2\_config](#input\_rke2\_config) | Additional RKE2 configuration to add to the config.yaml file | `string` | `null` | no |
| <a name="input_rke2_ingress"></a> [rke2\_ingress](#input\_rke2\_ingress) | RKE2 ingress deployed (nginx or traefik) | `string` | `"nginx"` | no |
| <a name="input_rke2_token"></a> [rke2\_token](#input\_rke2\_token) | Token to use when configuring RKE2 nodes | `string` | `null` | no |
| <a name="input_rke2_version"></a> [rke2\_version](#input\_rke2\_version) | Kubernetes version to use for the RKE2 cluster | `string` | `null` | no |
| <a name="input_ssh_key_pair_name"></a> [ssh\_key\_pair\_name](#input\_ssh\_key\_pair\_name) | Specify the SSH key name to use (that's already present in DigitalOcean) | `string` | `null` | no |
| <a name="input_ssh_key_pair_path"></a> [ssh\_key\_pair\_path](#input\_ssh\_key\_pair\_path) | Path to the private key of ssh\_key\_pair\_name. Terraform cannot use a passphrase-protected key | `string` | `null` | no |
| <a name="input_ssh_private_key_path"></a> [ssh\_private\_key\_path](#input\_ssh\_private\_key\_path) | Path to write the generated SSH private key | `string` | `null` | no |
| <a name="input_ssh_username"></a> [ssh\_username](#input\_ssh\_username) | The user account used to connect to droplets via ssh | `string` | `"root"` | no |
| <a name="input_tag_begin"></a> [tag\_begin](#input\_tag\_begin) | tag number added to DigitalOcean droplet | `number` | `2` | no |
| <a name="input_user_tag"></a> [user\_tag](#input\_user\_tag) | Name of the person deploying, set as the user: tag on every droplet (e.g. "jdoe"). Defaults to prefix | `string` | `null` | no |
| <a name="input_waiting_time"></a> [waiting\_time](#input\_waiting\_time) | An optional wait before installing the Rancher helm chart | `string` | `"20s"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instances_private_ip"></a> [instances\_private\_ip](#output\_instances\_private\_ip) | n/a |
| <a name="output_instances_public_ip"></a> [instances\_public\_ip](#output\_instances\_public\_ip) | n/a |
| <a name="output_kube_audit_log_command"></a> [kube\_audit\_log\_command](#output\_kube\_audit\_log\_command) | How to read the Kubernetes API audit log of the Rancher (local) cluster on a node |
| <a name="output_kube_config_path"></a> [kube\_config\_path](#output\_kube\_config\_path) | Kubeconfig for the Rancher (local) cluster |
| <a name="output_rancher_audit_log_command"></a> [rancher\_audit\_log\_command](#output\_rancher\_audit\_log\_command) | How to read the Rancher API audit log |
| <a name="output_rancher_token"></a> [rancher\_token](#output\_rancher\_token) | Rancher API token for the admin user (read by the downstream recipes) |
| <a name="output_rancher_url"></a> [rancher\_url](#output\_rancher\_url) | Rancher URL |
| <a name="output_ssh_private_key_path"></a> [ssh\_private\_key\_path](#output\_ssh\_private\_key\_path) | Private key used for SSH access to the droplets |
| <a name="output_ssh_username"></a> [ssh\_username](#output\_ssh\_username) | User for SSH access to the droplets |
