# Downstream | AWS | V2

This module is used to create a rancher-launched RKE2/k3s downstream cluster.

## Usage

```bash
git clone https://github.com/rancherlabs/tf-rancher-up.git
cd recipes/downstream/aws/v2
```

- Copy `terraform.tfvars.example` to `terraform.tfvars`
- Edit `terraform.tfvars`
  - Update the required variables:
    - Recommended: Configure an existing cloud credential ID in Rancher. Alternatively uncomment aws_access_key and aws_secret_key variables to create a cloud credential
    - Set the `aws_region`, and a name for the cluster (`cluster_name`)
    - Add the Rancher server URL as well an API token. The API token can be obtained by navigating through the Rancher UI -> Profile Icon -> Account and API Keys
    - Optional: enable spot instances on worker nodes by setting `worker_spot_instances` to `true`

Execute the below commands to start deployment.

```bash
terraform init
terraform plan
terraform apply
```

Once the deployment is successful, the terraform code will display the successful creation message.

## Multiple machine pools

`machine_pools` is optional. When set, it replaces the legacy `cp_*` and `worker_*` pool settings. Each pool declares its roles explicitly and creates its own machine config, allowing different placement and sizing per pool.

```hcl
machine_pools = [
  {
    name  = "cp-a"
    roles = ["etcd", "controlplane"]
    zone  = "a"

    # count               = 1            # optional; defaults to 1
    # drain_before_delete = true         # optional; defaults to true
    # subnet_id           = "subnet-aaa" # optional; falls back to the global subnet_id, then VPC/default VPC lookup
    # instance_type       = "t3a.medium" # optional; defaults to the global instance_type
    # volume_size         = 20           # optional; defaults to the global volume_size
    # volume_type         = "gp3"        # optional; defaults to the global volume_type
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

    # instance_type = "t3a.large" # optional; defaults to the global instance_type
    # volume_size   = 80          # optional; defaults to the global volume_size
  },
  {
    name  = "w-b"
    roles = ["worker"]
    count = 2
    zone  = "b"
  },
]
```

Each pool must declare at least one role: `etcd`, `controlplane`, or `worker`.

| Pool field | Fallback |
|---|---|
| `count` | `1` |
| `drain_before_delete` | `true` |
| `zone` | global `zone` |
| `subnet_id` | global `subnet_id`, then VPC/default VPC lookup |
| `instance_type` | global `instance_type` |
| `volume_size` | global `volume_size` |
| `volume_type` | global `volume_type` (`gp3`) |
| `spot_instances` | `false` (the global cp/worker spot flags only apply to legacy pools) |

Comment out the global `subnet_id` to let each pool resolve a subnet by zone. Set a pool's `subnet_id` explicitly to pin it to a specific subnet.

- Destroy the resources when cluster is no more needed.
```bash
terraform destroy
```
