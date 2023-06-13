# Terraform | RKE Cluster

Terraform module to create an RKE cluster. It supports single and HA cluster configurations.

### Usage

#### Single node cluster

```hcl
module "rke" {
  source = "github.com/terraform-rancher-modules/terraform-rke-cluster"

  node_public_ip = "192.168.236.121"
  node_username = "ubuntu"
  ssh_private_key_pem = "~/.ssh/id_rsa"
}
```

#### HA cluster

```hcl
module "rke" {
  source = "github.com/terraform-rancher-modules/terraform-rke-cluster"

  rancher_nodes = [
    {
      public_ip = "192.168.236.121",
      private_ip = "192.168.236.121",
      roles = ["etcd", "controlplane", "worker"]
    },
    {
      public_ip = "192.168.236.122",
      private_ip = "192.168.236.122",
      roles = ["etcd", "controlplane", "worker"]
    },
    {
      public_ip = "192.168.236.123",
      private_ip = "192.168.236.123",
      roles = ["etcd", "controlplane", "worker"]
    }
  ]

  cluster_yaml = "./cluster.yaml"
}
```

---

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.1.0 |
| <a name="requirement_rke"></a> [rke](#requirement\_rke) | >= 1.4.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | >= 2.1.0 |
| <a name="provider_rke"></a> [rke](#provider\_rke) | >= 1.4.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [local_file.kube_config_yaml](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.kube_config_yaml_backup](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [rke_cluster.this](https://registry.terraform.io/providers/rancher/rke/latest/docs/resources/cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name for the RKE cluster | `string` | `"rke-demo"` | no |
| <a name="input_cluster_yaml"></a> [cluster\_yaml](#input\_cluster\_yaml) | cluster.yaml configuration file to apply to the cluster | `string` | `null` | no |
| <a name="input_dependency"></a> [dependency](#input\_dependency) | An optional variable to add a dependency from another resource (not used) | `any` | `null` | no |
| <a name="input_kube_config_path"></a> [kube\_config\_path](#input\_kube\_config\_path) | The path to write the kubeconfig for the RKE cluster | `string` | `null` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version to use for the RKE cluster | `string` | `null` | no |
| <a name="input_node_internal_ip"></a> [node\_internal\_ip](#input\_node\_internal\_ip) | Internal IP address for single node RKE cluster | `string` | `null` | no |
| <a name="input_node_public_ip"></a> [node\_public\_ip](#input\_node\_public\_ip) | Public IP address for single node RKE cluster | `string` | `null` | no |
| <a name="input_node_username"></a> [node\_username](#input\_node\_username) | Username used for SSH access to the Rancher server cluster node | `string` | `"ubuntu"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix added to names of all resources | `string` | `null` | no |
| <a name="input_private_registry_password"></a> [private\_registry\_password](#input\_private\_registry\_password) | Specify private registry's password | `string` | `null` | no |
| <a name="input_private_registry_url"></a> [private\_registry\_url](#input\_private\_registry\_url) | Specify the private registry where kubernetes images are hosted. Ex: artifactory.company.com/docker | `string` | `null` | no |
| <a name="input_private_registry_username"></a> [private\_registry\_username](#input\_private\_registry\_username) | Specify private registry's username | `string` | `null` | no |
| <a name="input_rancher_nodes"></a> [rancher\_nodes](#input\_rancher\_nodes) | List of compute nodes for Rancher cluster | <pre>list(object({<br>    public_ip  = string<br>    private_ip = string<br>    roles      = list(string)<br>  }))</pre> | `null` | no |
| <a name="input_ssh_agent_auth"></a> [ssh\_agent\_auth](#input\_ssh\_agent\_auth) | Enable SSH agent authentication | `bool` | `false` | no |
| <a name="input_ssh_private_key_path"></a> [ssh\_private\_key\_path](#input\_ssh\_private\_key\_path) | Private key used for SSH access to the Rancher server cluster node(s) | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dependency"></a> [dependency](#output\_dependency) | n/a |
| <a name="output_rke_kubeconfig_filename"></a> [rke\_kubeconfig\_filename](#output\_rke\_kubeconfig\_filename) | Kubeconfig file location |