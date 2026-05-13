# tf-rancher-up

This repository maintains reusable terraform modules to deploy Rancher and Kubernetes clusters managed by Rancher.

The modules support major infrastructure/cloud platforms (AWS, VMware, Azure, GCP, DigitalOcean). Provisioning can be customized using different Kubernetes distributions (RKE, RKE2, K3S, EKS, AKS, GKE).

## Architecture

The project uses two main concepts:

* **[Modules](./modules)**: Focused, reusable building blocks that handle specific infrastructure components.
* **[Recipes](./recipes)**: Compositions of modules that provision full, end-to-end stacks.

We define clusters in two ways:

* **Upstream (Management Cluster)**: The cluster where Rancher is installed and runs.
* **Downstream (Workload Cluster)**: Clusters managed by Rancher where your applications run.

## Quick Start: AWS RKE2 Upstream

Use these steps to set up a Rancher management cluster on AWS with RKE2.

1. Clone the repository and navigate to the recipe directory:
   ```bash
   git clone https://github.com/rancher/tf-rancher-up.git
   cd tf-rancher-up/recipes/upstream/aws/rke2
   ```
2. Create your configuration file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```
3. Edit `terraform.tfvars` with your AWS credentials, region, and desired settings.
4. Initialize and apply the configuration:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Quick Start: DigitalOcean RKE2 Upstream

Use these steps to set up a Rancher management cluster on DigitalOcean with RKE2.

1. Clone the repository and navigate to the recipe directory:
   ```bash
   git clone https://github.com/rancher/tf-rancher-up.git
   cd tf-rancher-up/recipes/upstream/digitalocean/rke2
   ```
2. Create your configuration file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```
3. Edit `terraform.tfvars` with your DigitalOcean token, region, and desired settings.
4. Initialize and apply the configuration:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Recipes

| Provider | Upstream Recipes | Downstream/Standalone Recipes |
| :--- | :--- | :--- |
| AWS | [RKE](./recipes/upstream/aws/rke), [RKE2](./recipes/upstream/aws/rke2), [K3S](./recipes/upstream/aws/k3s) | [v2](./recipes/downstream/aws/v2), [EKS](./recipes/downstream/aws/EKS), [RKE](./recipes/downstream/aws/rke), [Split-roles RKE](./recipes/rke/split-roles/aws) |
| Azure | [RKE](./recipes/upstream/azure/rke), [RKE2](./recipes/upstream/azure/rke2), [K3S](./recipes/upstream/azure/k3s), [AKS](./recipes/upstream/azure/aks) | None |
| Google Cloud | [RKE](./recipes/upstream/google-cloud/rke), [RKE2](./recipes/upstream/google-cloud/rke2), [K3S](./recipes/upstream/google-cloud/k3s), [GKE](./recipes/upstream/google-cloud/gke) | [GKE](./recipes/downstream/gcp/GKE) |
| DigitalOcean | [RKE](./recipes/upstream/digitalocean/rke), [RKE2](./recipes/upstream/digitalocean/rke2), [K3S](./recipes/upstream/digitalocean/k3s) | None |
| VMware | [RKE](./recipes/upstream/vmware/rke), [RKE2](./recipes/upstream/vmware/rke2), [K3S](./recipes/upstream/vmware/k3s) | None |
