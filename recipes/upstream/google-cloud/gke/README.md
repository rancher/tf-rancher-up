# Upstream | Google Cloud | GKE

This module is used to establish a Rancher (local) management cluster using [Google Kubernetes Engine](https://cloud.google.com/kubernetes-engine).

Documentation can be found [here](./docs.md).

## Usage

```bash
git clone https://github.com/rancherlabs/tf-rancher-up.git
cd recipes/upstream/google-cloud/gke
```

- Copy `./terraform.tfvars.example` to `./terraform.tfvars`
- Edit `./terraform.tfvars`
  - Update the required variables:
    -  `prefix` to give the resources an identifiable name (eg, your initials or first name)
    -  `project_id` to specify in which Project the resources will be created
    -  `region` to suit your region
    -  `rancher_hostname` in order to reach the Rancher console via DNS name
- Make sure you are logged into your Google Account from your local Terminal. See the preparatory steps [here](../../../../modules/infra/google-cloud/README.md).

**NB: If you want to use all the configurable variables in the `terraform.tfvars` file, you will need to uncomment them there and in the `variables.tf` and `main.tf` files.**

```bash
terraform init --upgrade ; terraform apply -target=module.google-kubernetes-engine --auto-approve ; terraform apply --auto-approve
```

- Destroy the resources when finished
```bash
terraform state rm module.google-kubernetes-engine.local_file.kube-config-export ; terraform destroy -target=module.google-kubernetes-engine --auto-approve ; terraform destroy --auto-approve
```

See full argument list for each module in use:
  - Google Network Services: https://github.com/rancherlabs/tf-rancher-up/tree/main/modules/infra/google-cloud/network-services
  - Google Kubernetes Engine: https://github.com/rancherlabs/tf-rancher-up/tree/main/modules/distribution/gke
  - Rancher: https://github.com/rancherlabs/tf-rancher-up/tree/main/modules/rancher
