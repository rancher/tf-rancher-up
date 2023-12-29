## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rancher_install"></a> [rancher\_install](#module\_rancher\_install) | ../../../../modules/rancher | n/a |
| <a name="module_rke"></a> [rke](#module\_rke) | ../../../../modules/distribution/rke | n/a |
| <a name="module_upstream-cluster"></a> [upstream-cluster](#module\_upstream-cluster) | ../../../../modules/infra/digitalocean | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_do_token"></a> [do\_token](#input\_do\_token) | DigitalOcean Authentication Token | `string` | `null` | no |
| <a name="input_droplet_count"></a> [droplet\_count](#input\_droplet\_count) | Number of droplets to create | `number` | `3` | no |
| <a name="input_droplet_size"></a> [droplet\_size](#input\_droplet\_size) | Size used for all droplets | `string` | `"s-2vcpu-4gb"` | no |
| <a name="input_kube_config_path"></a> [kube\_config\_path](#input\_kube\_config\_path) | The path to write the kubeconfig for the RKE cluster | `string` | `null` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version to use for the RKE cluster | `string` | `null` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix added to names of all resources | `string` | `"rancher-terraform"` | no |
| <a name="input_rancher_password"></a> [rancher\_password](#input\_rancher\_password) | Password to use for bootstrapping Rancher (min 12 characters) | `string` | `"initial-admin-password"` | no |
| <a name="input_rancher_version"></a> [rancher\_version](#input\_rancher\_version) | Rancher version to install | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | Region that droplets will be deployed to | `string` | `"sfo3"` | no |
| <a name="input_ssh_key_name"></a> [ssh\_key\_name](#input\_ssh\_key\_name) | Name of the public ssh key stored on DigitalOcean | `string` | n/a | yes |
| <a name="input_ssh_private_key_path"></a> [ssh\_private\_key\_path](#input\_ssh\_private\_key\_path) | Path to the private ssh key that matches the public ssh key from DigitalOcean | `any` | n/a | yes |
| <a name="input_ssh_username"></a> [ssh\_username](#input\_ssh\_username) | The user account used to connect to droplets via ssh | `string` | `"root"` | no |
| <a name="input_tag_begin"></a> [tag\_begin](#input\_tag\_begin) | Tag from this number when module is called more than once | `number` | `1` | no |
| <a name="input_user_tag"></a> [user\_tag](#input\_user\_tag) | FirstInitialLastname of user | `string` | n/a | yes |
| <a name="input_wait"></a> [wait](#input\_wait) | An optional wait before installing the Rancher helm chart | `string` | `"20s"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_droplets_private_ip"></a> [droplets\_private\_ip](#output\_droplets\_private\_ip) | n/a |
| <a name="output_droplets_public_ip"></a> [droplets\_public\_ip](#output\_droplets\_public\_ip) | n/a |
| <a name="output_rancher_hostname"></a> [rancher\_hostname](#output\_rancher\_hostname) | n/a |
| <a name="output_rancher_password"></a> [rancher\_password](#output\_rancher\_password) | n/a |
