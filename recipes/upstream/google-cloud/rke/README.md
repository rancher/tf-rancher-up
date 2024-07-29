# Upstream | Google Cloud | Compute Engine x RKE

This module is used to establish a Rancher (local) management cluster using [Google Compute Engine](https://cloud.google.com/compute?hl=en) and [RKE](https://rke.docs.rancher.com/).

Documentation can be found [here](./docs.md).

## Usage

```bash
git clone https://github.com/rancherlabs/tf-rancher-up.git
cd recipes/upstream/google-cloud/rke
```

- Copy `./terraform.tfvars.exmaple` to `./terraform.tfvars`
- Edit `./terraform.tfvars`
  - Update the required variables:
    -  `prefix` to give the resources an identifiable name (eg, your initials or first name)
    -  `project_id` to specify in which Project the resources will be created
    -  `region` to suit your region
    -  `ssh_username` to specify the user used to create the VMs (default "ubuntu")
    -  `startup_script` for installing Docker if you are not using a ready-made image (only required if the user the VMs were installed under is not "ubuntu")
    -  `rancher_hostname` in order to reach the Rancher console via DNS name
    -  `rancher_password` to configure the initial Admin password (the password must be at least 12 characters)
- Make sure you are logged into your Google Account from your local Terminal. See the preparatory steps [here](../../../../modules/infra/google-cloud/README.md).

**NB: If you want to use all the configurable variables in the `terraform.tfvars` file, you will need to uncomment them there and in the `variables.tf` and `main.tf` files.**

```bash
terraform init -upgrade && terraform apply -auto-approve
```

- Destroy the resources when finished
```bash
terraform destroy -auto-approve
```

See full argument list for each module in use:
  - Google Compute Engine: https://github.com/rancherlabs/tf-rancher-up/tree/main/modules/infra/google-cloud/compute-engine
  - RKE: https://github.com/rancherlabs/tf-rancher-up/tree/main/modules/distribution/rke
  - Rancher: https://github.com/rancherlabs/tf-rancher-up/tree/main/modules/rancher
