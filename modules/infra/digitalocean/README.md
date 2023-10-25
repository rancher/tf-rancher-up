# Terraform | DigitalOcean Infrastructure

Terraform module to provide DigitalOcean nodes prepared for an RKEv1 cluster.

Basic infrastructure options are provided to be coupled with other modules for example environments, not suitable for advanced or production use cases.


---

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | >= 2.30.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | >= 2.30.0 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [digitalocean_droplet.droplet](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/droplet) | resource |
| [digitalocean_firewall.k8s_cluster](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/firewall) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="do_token"></a> [do\_token](#input\_do\_token) | DigitalOcean authentication token | `string` | `null` | yes |
| <a name="droplet_count"></a> [droplet\_count](#input\_droplet\_count) | Number of droplets to create | `number` | `3` | no |
| <a name="droplet_size"></a> [droplet\_size](#input\_droplet\_size) | Size used for all droplets | `string` | `s-2vcpu-4gb` | no |
| <a name="prefix"></a> [prefix](#input\_prefix) | Prefix added to the names of all resources | `string` | `rancher-terraform` | no |
| <a name="tag_begin"></a> [tag\_begin](#input\_tag\_begin) | Tag from this number when the module is called more than once | `number` | `1` | no |
| <a name="user_tag"></a> [user\_tag](#input\_user\_tag) | User tag in `FirstInitialLastName` format | `string` | `null` | yes |
| <a name="ssh_key_name"></a> [ssh\_key\_name](#input\_ssh\_key\_name) | Name of the public ssh key stored on DigitalOcean | `string` | `null` | no |
| <a name="ssh_private_key_path"></a> [ssh\_private\_key\_path](#input\_ssh\_private\_key\_path) | Local path to the private ssh key that matches the `ssh_key_name` stored on DigitalOcean | `string` | `null` | yes |
| <a name="region"></a> [region](#input\_region) | Region targeted for droplet deployment | `string` | `sfo3` | no |
| <a name="user_data"></a> [user\_data](#input\_user\_data) | User data content used for DigitalOcean droplets | `any` | `null` | no |

## Outputs  

| Name | Description |
|------|-------------|
| <a name="output_dependency"></a> [dependency](#output\_dependency) | n/a |
| <a name="output_droplets_public_ip"></a> [droplets\_public\_ip](#output\_droplets\_public\_ip) | n/a |
| <a name="output_droplets_private_ip"></a> [droplets\_private\_ip](#output\_droplets\_private\_ip) | n/a |
| <a name="output_ips"></a> [droplets\_ips](#output\_droplets\_ips) | n/a |
| <a name="output_ssh_private_key_path"></a> [ssh\_private\_key\_path](#output\_private\_key\_path) | n/a |
