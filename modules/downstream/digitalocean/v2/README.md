# Downstream | DigitalOcean | V2

Terraform module to create a Rancher-managed RKE2/K3s downstream cluster using the Rancher DigitalOcean node driver.

## Examples

### Legacy control-plane and worker pools

```terraform
module "downstream_rke2" {
  source = "git::https://github.com/rancher/tf-rancher-up.git//modules/downstream/digitalocean/v2/"

  cluster_name = "tf-test"

  do_token   = "dop_v1_xxx"
  region     = "sfo3"
  size       = "s-2vcpu-4gb"
  image      = "ubuntu-24-04-x64"
  ssh_user   = "root"

  kubernetes_version = "v1.35.6+rke2r1"

  cp_count     = 3
  worker_count = 2
}
```

### Multiple machine pools across regions/sizes

```terraform
module "downstream_rke2" {
  source = "git::https://github.com/rancher/tf-rancher-up.git//modules/downstream/digitalocean/v2/"

  cluster_name = "tf-test"

  do_token   = "dop_v1_xxx"
  region     = "sfo3"
  size       = "s-2vcpu-4gb"
  image      = "ubuntu-24-04-x64"
  ssh_user   = "root"

  kubernetes_version = "v1.35.6+rke2r1"

  machine_pools = [
    {
      name  = "cp-a"
      roles = ["etcd", "controlplane"]
    },
    {
      name  = "w-a"
      roles = ["worker"]
      count = 2
      size  = "s-4vcpu-8gb"
    },
  ]
}
```

## Custom user data

`custom_user_data` is passed to the machine driver `userdata` field. See the AWS v2 module for the equivalent semantics.