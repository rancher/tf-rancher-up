# Terraform | GCP GKE

Terraform module to provision a GCP GKE cluster.

Documentation can be found [here](./docs.md).

## Examples

#### Launch a GKE cluster using an existing cloud credential in Rancher

```terraform
module "downstream_eks" {
  source              = "git::https://github.com/rancherlabs/tf-rancher-up.git//modules/downstream/gcp/GKE/"
  rancher_url         = "https://example.com"
  rancher_token       = "token-xxxx:yyyy"
  cloud_credential_id = "cattle-global-data:cc-xxx"
  region              = "us-east1-b"
  cluster_name        = "tf-gke-testing"
  project_id          = "testing-project"
  kubernetes_version  = "1.33.3-gke.1136000"
  node_pools = [
    {
      name                = "worker-pool-1"
      initial_node_count  = 1
      max_pods_constraint = 110
    }
  ]
  cluster_description = "Testing GKE cluster"
}
```

Available GKE versions can be found at: https://cloud.google.com/kubernetes-engine/docs/release-notes