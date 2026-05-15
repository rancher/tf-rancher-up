# Imported Cluster Module

This module creates an imported cluster in Rancher using the v2 provisioning engine.
It provides the registration command and manifest URL to be applied on the existing downstream cluster.

## Usage

```hcl
module "imported_cluster" {
  source = "../../modules/downstream/imported"

  cluster_name       = "my-imported-cluster"
}
```
