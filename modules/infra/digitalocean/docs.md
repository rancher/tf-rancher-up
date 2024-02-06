## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | ~> 2.30.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | ~> 2.30.0 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [digitalocean_droplet.droplet](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/droplet) | resource |
| [digitalocean_firewall.k8s_cluster](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/firewall) | resource |
| [digitalocean_ssh_key.key_pair](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/ssh_key) | resource |
| [local_file.private_key_pem](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [tls_private_key.ssh_private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [digitalocean_image.ubuntu](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/data-sources/image) | data source |
| [digitalocean_ssh_key.terraform](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/data-sources/ssh_key) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_ssh_key_pair"></a> [create\_ssh\_key\_pair](#input\_create\_ssh\_key\_pair) | Specify if a new SSH key pair needs to be created for the instances | `bool` | `false` | no |
| <a name="input_do_token"></a> [do\_token](#input\_do\_token) | DigitalOcean Authentication Token | `string` | `null` | no |
| <a name="input_droplet_count"></a> [droplet\_count](#input\_droplet\_count) | Number of droplets to create | `number` | `3` | no |
| <a name="input_droplet_size"></a> [droplet\_size](#input\_droplet\_size) | Size used for all droplets | `string` | `"s-2vcpu-4gb"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix added to names of all resources | `string` | `"rancher-terraform"` | no |
| <a name="input_region"></a> [region](#input\_region) | Region that droplets will be deployed to | `string` | `"sfo3"` | no |
| <a name="input_ssh_key_pair_name"></a> [ssh\_key\_pair\_name](#input\_ssh\_key\_pair\_name) | Specify the SSH key name to use (that's already present in DigitalOcean) | `string` | `null` | no |
| <a name="input_ssh_key_pair_path"></a> [ssh\_key\_pair\_path](#input\_ssh\_key\_pair\_path) | Path to the SSH private key used as the key pair (that's already present in DigitalOcean) | `string` | `null` | no |
| <a name="input_ssh_private_key_path"></a> [ssh\_private\_key\_path](#input\_ssh\_private\_key\_path) | Path to write the generated SSH private key | `string` | `null` | no |
| <a name="input_tag_begin"></a> [tag\_begin](#input\_tag\_begin) | Tag from this number when module is called more than once | `number` | `1` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | User data content for EC2 instance(s) | `any` | `null` | no |
| <a name="input_user_tag"></a> [user\_tag](#input\_user\_tag) | FirstInitialLastname of user | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dependency"></a> [dependency](#output\_dependency) | n/a |
| <a name="output_droplet_ips"></a> [droplet\_ips](#output\_droplet\_ips) | n/a |
| <a name="output_droplets_private_ip"></a> [droplets\_private\_ip](#output\_droplets\_private\_ip) | n/a |
| <a name="output_droplets_public_ip"></a> [droplets\_public\_ip](#output\_droplets\_public\_ip) | n/a |
| <a name="output_ssh_key_pair_name"></a> [ssh\_key\_pair\_name](#output\_ssh\_key\_pair\_name) | n/a |
| <a name="output_ssh_key_path"></a> [ssh\_key\_path](#output\_ssh\_key\_path) | n/a |
