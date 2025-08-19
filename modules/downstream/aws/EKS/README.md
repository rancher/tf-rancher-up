# Terraform | AWS EKS

Terraform module to provision an AWS EKS cluster.

Documentation can be found [here](./docs.md).

## Examples

#### Launch an EKS cluster using an existing cloud credential in Rancher

```terraform
module "downstream_eks" {
  source              = "git::https://github.com/rancherlabs/tf-rancher-up.git//modules/downstream/aws/EKS/"
  cloud_credential_id = "cattle-global-data:cc-xxx"
  aws_region          = "us-east-1"
  cluster_name        = "tf-eks-testing"
  kubernetes_version  = 1.32
  node_groups         = [
    {
      name          = "worker-pool-1"
      instance_type = "t3.medium"
      desired_size  = 2
      max_size      = 3
      min_size      = 1
    }
  ]
  cluster_description = "Testing EKS cluster"
}
```