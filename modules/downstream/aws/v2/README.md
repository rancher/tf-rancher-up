# Downstream | AWS | V2

Terraform module to create a Rancher-managed RKE2/K3s downstream cluster using the Rancher AWS node driver.

Documentation can be found [here](./docs.md).

## Examples

### Legacy control-plane and worker pools

Configure the `rancher2` provider in the root module. Leaving `machine_pools` unset keeps the legacy cp/worker pool behaviour.

```terraform
module "downstream_rke2" {
  source = "git::https://github.com/rancher/tf-rancher-up.git//modules/downstream/aws/v2/"

  cluster_name = "tf-test"

  aws_region          = "us-east-1"
  vpc_id              = "vpc-xxx"
  subnet_id           = "subnet-xxx"
  security_group_name = "rancher-nodes"
  ssh_user            = "ubuntu"

  kubernetes_version = "v1.35.6+rke2r1"

  cp_count     = 3
  worker_count = 2
}
```

### Multiple machine pools across availability zones

When `machine_pools` is set, it replaces the legacy cp/worker pools. Each pool creates its own machine config, so placement and sizing can differ per pool. Fields that are not set fall back to the module-level globals.

```terraform
module "downstream_rke2" {
  source = "git::https://github.com/rancher/tf-rancher-up.git//modules/downstream/aws/v2/"

  cluster_name = "tf-test"

  aws_region          = "us-east-1"
  vpc_id              = "vpc-xxx"
  security_group_name = "rancher-nodes"
  ssh_user            = "ubuntu"

  kubernetes_version = "v1.35.6+rke2r1"

  # Global fallbacks for machine pool fields that are not set
  instance_type = "t3a.medium"
  volume_size   = 20
  volume_type   = "gp3"

  machine_pools = [
    {
      name  = "cp-a"
      roles = ["etcd", "controlplane"]
      zone  = "a"

      # count               = 1            # optional; defaults to 1
      # drain_before_delete = true         # optional; defaults to true
      # subnet_id           = "subnet-aaa" # optional; falls back to subnet_id, then VPC/default VPC lookup
      # instance_type       = "t3a.medium" # optional; defaults to module instance_type
      # volume_size         = 20           # optional; defaults to module volume_size
      # volume_type         = "gp3"        # optional; defaults to module volume_type
      # spot_instances      = false        # optional; defaults to false
    },
    {
      name  = "cp-b"
      roles = ["etcd", "controlplane"]
      zone  = "b"
    },
    {
      name  = "cp-c"
      roles = ["etcd", "controlplane"]
      zone  = "c"
    },
    {
      name  = "w-a"
      roles = ["worker"]
      count = 2
      zone  = "a"

      # instance_type = "t3a.large" # optional; defaults to module instance_type
      # volume_size   = 80          # optional; defaults to module volume_size
    },
    {
      name  = "w-b"
      roles = ["worker"]
      count = 2
      zone  = "b"
    },
  ]
}
```
