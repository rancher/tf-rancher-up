## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9 |
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | >= 2.30.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.1.0 |
| <a name="requirement_rancher2"></a> [rancher2](#requirement\_rancher2) | >= 8.0.0 |
| <a name="requirement_ssh"></a> [ssh](#requirement\_ssh) | >= 2.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | 2.102.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.9.1 |
| <a name="provider_rancher2"></a> [rancher2](#provider\_rancher2) | 15.1.2 |
| <a name="provider_ssh"></a> [ssh](#provider\_ssh) | 2.7.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rke2_servers"></a> [rke2\_servers](#module\_rke2\_servers) | ../../../../modules/infra/digitalocean/ | n/a |

## Resources

| Name | Type |
|------|------|
| [digitalocean_vpc.cluster](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/vpc) | resource |
| [local_sensitive_file.kubeconfig](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/sensitive_file) | resource |
| [rancher2_cluster_sync.downstream](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster_sync) | resource |
| [rancher2_cluster_v2.downstream](https://registry.terraform.io/providers/rancher/rancher2/latest/docs/resources/cluster_v2) | resource |
| [ssh_resource.register_servers](https://registry.terraform.io/providers/loafoe/ssh/latest/docs/resources/resource) | resource |
| [terraform_remote_state.upstream](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorized_cluster_endpoint"></a> [authorized\_cluster\_endpoint](#input\_authorized\_cluster\_endpoint) | Authorized Cluster Endpoint (ACE): kubeconfigs downloaded from Rancher get contexts that reach this cluster's API server directly, bypassing Rancher (it keeps working if Rancher is down). Those requests appear only in the Kubernetes audit log (kube\_audit\_level), never in Rancher's | <pre>object({<br/>    enabled  = bool<br/>    fqdn     = optional(string)<br/>    ca_certs = optional(string)<br/>  })</pre> | <pre>{<br/>  "enabled": false<br/>}</pre> | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the downstream cluster in Rancher | `string` | `"do-downstream"` | no |
| <a name="input_create_firewall"></a> [create\_firewall](#input\_create\_firewall) | Specify if a firewall to access droplets needs to be created for the instances | `bool` | `true` | no |
| <a name="input_create_https_loadbalancer"></a> [create\_https\_loadbalancer](#input\_create\_https\_loadbalancer) | Specify if a loadbalancer for port 443 needs to be created for the instances | `bool` | `false` | no |
| <a name="input_create_k8s_api_loadbalancer"></a> [create\_k8s\_api\_loadbalancer](#input\_create\_k8s\_api\_loadbalancer) | Specify if a loadbalancer for port 6443 needs to be created for the instances | `bool` | `false` | no |
| <a name="input_create_ssh_key_pair"></a> [create\_ssh\_key\_pair](#input\_create\_ssh\_key\_pair) | Specify if a new SSH key pair needs to be created for the instances | `bool` | `true` | no |
| <a name="input_do_token"></a> [do\_token](#input\_do\_token) | DigitalOcean Authentication Token | `string` | n/a | yes |
| <a name="input_droplet_count"></a> [droplet\_count](#input\_droplet\_count) | Number of droplets to create. Every node runs all roles (etcd, control plane, worker), so use 1 or an odd number (3, 5) | `number` | `3` | no |
| <a name="input_droplet_image"></a> [droplet\_image](#input\_droplet\_image) | name of the OpenSUSE custom image uploaded to DigitalOcean account | `string` | `"openSUSE-Leap-15.6"` | no |
| <a name="input_droplet_size"></a> [droplet\_size](#input\_droplet\_size) | Size used for all droplets | `string` | `"s-2vcpu-4gb"` | no |
| <a name="input_kube_audit_level"></a> [kube\_audit\_level](#input\_kube\_audit\_level) | Kubernetes API audit level on the control-plane nodes: None (disabled), Metadata (who, what, when), Request (+ request bodies) or RequestResponse (+ response bodies). Secrets, ConfigMaps and token reviews are always capped at Metadata | `string` | `"None"` | no |
| <a name="input_kube_audit_log_max_age"></a> [kube\_audit\_log\_max\_age](#input\_kube\_audit\_log\_max\_age) | Days to keep rotated Kubernetes audit log files | `number` | `30` | no |
| <a name="input_kube_audit_log_max_backup"></a> [kube\_audit\_log\_max\_backup](#input\_kube\_audit\_log\_max\_backup) | Number of rotated Kubernetes audit log files to keep | `number` | `10` | no |
| <a name="input_kube_audit_log_max_size"></a> [kube\_audit\_log\_max\_size](#input\_kube\_audit\_log\_max\_size) | Size in MB at which the Kubernetes audit log file is rotated | `number` | `100` | no |
| <a name="input_kube_audit_policy"></a> [kube\_audit\_policy](#input\_kube\_audit\_policy) | Full Kubernetes audit Policy YAML to use instead of the one generated from kube\_audit\_level | `string` | `null` | no |
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | Operating system type (opensuse or ubuntu) | `string` | `"opensuse"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix added to names of all resources. Must be unique in the DigitalOcean account (VPC names are account-wide) and a valid DNS label, as it becomes part of the Kubernetes node names | `string` | `"rancher-downstream"` | no |
| <a name="input_private_network_interface"></a> [private\_network\_interface](#input\_private\_network\_interface) | Droplet interface attached to the VPC; Canal's overlay network is pinned to it | `string` | `"eth1"` | no |
| <a name="input_rancher_api_url"></a> [rancher\_api\_url](#input\_rancher\_api\_url) | The URL of the upstream Rancher server (e.g. https://rancher.yourdomain.com). When null, it is read from upstream\_state\_path | `string` | `null` | no |
| <a name="input_rancher_insecure"></a> [rancher\_insecure](#input\_rancher\_insecure) | Skip TLS verification of the Rancher API (needed for the self-signed certificate of the upstream recipe) | `bool` | `true` | no |
| <a name="input_rancher_token_key"></a> [rancher\_token\_key](#input\_rancher\_token\_key) | API token for the upstream Rancher server. When null, it is read from upstream\_state\_path | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | Region that droplets will be deployed to | `string` | `"sfo3"` | no |
| <a name="input_rke2_ingress"></a> [rke2\_ingress](#input\_rke2\_ingress) | RKE2 ingress deployed (nginx or traefik) | `string` | `"nginx"` | no |
| <a name="input_rke2_version"></a> [rke2\_version](#input\_rke2\_version) | RKE2 version for the cluster; must be one the upstream Rancher offers (Cluster Management > Create > Custom) | `string` | `"v1.36.4+rke2r1"` | no |
| <a name="input_ssh_key_pair_name"></a> [ssh\_key\_pair\_name](#input\_ssh\_key\_pair\_name) | Specify the SSH key name to use (that's already present in DigitalOcean) | `string` | `null` | no |
| <a name="input_ssh_key_pair_path"></a> [ssh\_key\_pair\_path](#input\_ssh\_key\_pair\_path) | Path to the private key of ssh\_key\_pair\_name. Terraform cannot use a passphrase-protected key | `string` | `null` | no |
| <a name="input_ssh_private_key_path"></a> [ssh\_private\_key\_path](#input\_ssh\_private\_key\_path) | Path to write the generated SSH private key | `string` | `null` | no |
| <a name="input_ssh_username"></a> [ssh\_username](#input\_ssh\_username) | The user account used to connect to droplets via ssh | `string` | `"root"` | no |
| <a name="input_tag_begin"></a> [tag\_begin](#input\_tag\_begin) | tag number added to DigitalOcean droplet | `number` | `1` | no |
| <a name="input_upstream_state_path"></a> [upstream\_state\_path](#input\_upstream\_state\_path) | Path to the terraform.tfstate of the upstream recipe; its rancher\_url and rancher\_token outputs are used when rancher\_api\_url is null | `string` | `"../../../upstream/digitalocean/rke2/terraform.tfstate"` | no |
| <a name="input_user_tag"></a> [user\_tag](#input\_user\_tag) | Name of the person deploying, set as the user: tag on every droplet (e.g. "jdoe"). Defaults to prefix | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | Rancher (v1) cluster ID |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | n/a |
| <a name="output_instances_private_ip"></a> [instances\_private\_ip](#output\_instances\_private\_ip) | n/a |
| <a name="output_instances_public_ip"></a> [instances\_public\_ip](#output\_instances\_public\_ip) | n/a |
| <a name="output_kube_audit_log_command"></a> [kube\_audit\_log\_command](#output\_kube\_audit\_log\_command) | How to read the Kubernetes API audit log on a control-plane node |
| <a name="output_kube_config_path"></a> [kube\_config\_path](#output\_kube\_config\_path) | Kubeconfig for the downstream cluster (proxied through Rancher) |
| <a name="output_ssh_private_key_path"></a> [ssh\_private\_key\_path](#output\_ssh\_private\_key\_path) | Private key used for SSH access to the droplets |
| <a name="output_ssh_username"></a> [ssh\_username](#output\_ssh\_username) | User for SSH access to the droplets |
