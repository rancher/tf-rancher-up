## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14 |
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.4 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rancher_install"></a> [rancher\_install](#module\_rancher\_install) | ../../../../modules/rancher | n/a |
| <a name="module_rke"></a> [rke](#module\_rke) | ../../../../modules/distribution/rke | n/a |
| <a name="module_upstream-cluster"></a> [upstream-cluster](#module\_upstream-cluster) | ../../../../modules/infra/digitalocean | n/a |

## Resources

| Name | Type |
|------|------|
| [null_resource.wait-k8s-services-startup](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_https_loadbalancer"></a> [create\_https\_loadbalancer](#input\_create\_https\_loadbalancer) | Specify if a loadbalancer for port 443 needs to be created for the instances | `bool` | `false` | no |
| <a name="input_create_k8s_api_loadbalancer"></a> [create\_k8s\_api\_loadbalancer](#input\_create\_k8s\_api\_loadbalancer) | Specify if a loadbalancer for port 6443 needs to be created for the instances | `bool` | `false` | no |
| <a name="input_create_ssh_key_pair"></a> [create\_ssh\_key\_pair](#input\_create\_ssh\_key\_pair) | Specify if a new SSH key pair needs to be created for the instances | `bool` | `true` | no |
| <a name="input_do_token"></a> [do\_token](#input\_do\_token) | DigitalOcean Authentication Token | `string` | `null` | no |
| <a name="input_droplet_count"></a> [droplet\_count](#input\_droplet\_count) | Number of droplets to create | `number` | `3` | no |
| <a name="input_droplet_image"></a> [droplet\_image](#input\_droplet\_image) | name of the OpenSUSE custom image uploaded to DigitalOcean account | `string` | `"openSUSE-Leap-15.6"` | no |
| <a name="input_droplet_size"></a> [droplet\_size](#input\_droplet\_size) | Size used for all droplets | `string` | `"s-2vcpu-4gb"` | no |
| <a name="input_kube_config_filename"></a> [kube\_config\_filename](#input\_kube\_config\_filename) | Filename to write the kube config | `string` | `null` | no |
| <a name="input_kube_config_path"></a> [kube\_config\_path](#input\_kube\_config\_path) | The path to write the kubeconfig for the RKE cluster | `string` | `null` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version to use for the RKE cluster | `string` | `null` | no |
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | Operating system type (opensuse or ubuntu) | `string` | `"opensuse"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix added to names of all resources | `string` | `"rancher-terraform"` | no |
| <a name="input_rancher_bootstrap_password"></a> [rancher\_bootstrap\_password](#input\_rancher\_bootstrap\_password) | Password to use when bootstrapping Rancher (min 12 characters) | `string` | `"initial-bootstrap-password"` | no |
| <a name="input_rancher_helm_repository"></a> [rancher\_helm\_repository](#input\_rancher\_helm\_repository) | Helm repository for Rancher chart | `string` | `null` | no |
| <a name="input_rancher_helm_repository_password"></a> [rancher\_helm\_repository\_password](#input\_rancher\_helm\_repository\_password) | Private Rancher helm repository password | `string` | `null` | no |
| <a name="input_rancher_helm_repository_username"></a> [rancher\_helm\_repository\_username](#input\_rancher\_helm\_repository\_username) | Private Rancher helm repository username | `string` | `null` | no |
| <a name="input_rancher_password"></a> [rancher\_password](#input\_rancher\_password) | Password for the Rancher admin account (min 12 characters) | `string` | `null` | no |
| <a name="input_rancher_version"></a> [rancher\_version](#input\_rancher\_version) | Rancher version to install | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | Region that droplets will be deployed to | `string` | `"sfo3"` | no |
| <a name="input_ssh_key_pair_name"></a> [ssh\_key\_pair\_name](#input\_ssh\_key\_pair\_name) | Specify the SSH key name to use (that's already present in DigitalOcean) | `string` | `null` | no |
| <a name="input_ssh_key_pair_path"></a> [ssh\_key\_pair\_path](#input\_ssh\_key\_pair\_path) | Path to the SSH private key used as the key pair (that's already present in DigitalOcean) | `string` | `null` | no |
| <a name="input_ssh_private_key_path"></a> [ssh\_private\_key\_path](#input\_ssh\_private\_key\_path) | Path to write the generated SSH private key | `string` | `null` | no |
| <a name="input_ssh_username"></a> [ssh\_username](#input\_ssh\_username) | The user account used to connect to droplets via ssh | `string` | `"root"` | no |
| <a name="input_tag_begin"></a> [tag\_begin](#input\_tag\_begin) | Tag from this number when module is called more than once | `number` | `1` | no |
| <a name="input_wait"></a> [wait](#input\_wait) | An optional wait before installing the Rancher helm chart | `string` | `"20s"` | no |
| <a name="input_waiting_time"></a> [waiting\_time](#input\_waiting\_time) | Waiting time (in seconds) | `number` | `60` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_droplets_private_ip"></a> [droplets\_private\_ip](#output\_droplets\_private\_ip) | n/a |
| <a name="output_droplets_public_ip"></a> [droplets\_public\_ip](#output\_droplets\_public\_ip) | n/a |
| <a name="output_rancher_password"></a> [rancher\_password](#output\_rancher\_password) | n/a |
| <a name="output_rancher_url"></a> [rancher\_url](#output\_rancher\_url) | Rancher URL |
