# Custom Downstream Cluster Module

This module creates a custom downstream cluster in Rancher. It provides the registration tokens needed to join external nodes to the cluster.

## Usage

```hcl
module "custom_cluster" {
  source = "../../modules/downstream/custom"

  cluster_name       = "my-custom-cluster"
  kubernetes_version = "v1.34.7+rke2r1"
}
```
