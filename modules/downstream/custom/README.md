# Custom Downstream Cluster Module

This module creates a custom downstream cluster in Rancher for RKE2 or k3s. It provides the registration commands needed to join existing nodes to the cluster.

## Usage

```hcl
module "custom_cluster" {
  source = "../../modules/downstream/custom"

  cluster_name       = "my-custom-cluster"
  kubernetes_version = "v1.34.7+rke2r1"
}
```