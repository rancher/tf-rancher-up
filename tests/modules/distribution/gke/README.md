# TEST - GKE deploy

This directory has code to test the GKE distribution [module](../../../../modules/distribution/gke).

Documentation can be found [here](./docs.md).

## Usage

```bash
git clone https://github.com/rancherlabs/tf-rancher-up.git
cd tests/modules/distribution/gke
```

- Copy `./terraform.tfvars.example` to `./terraform.tfvars`
- Edit `./terraform.tfvars`
  - Update the required variables:
    -  `prefix` to give the resources an identifiable name (eg, your initials or first name)
    -  `project_id` to specify in which Project the resources will be created
    -  `region` to suit your region
- Make sure you are logged into your Google Account from your local Terminal. See the preparatory steps [here](../../../../modules/infra/google-cloud/README.md).

```bash
terraform init --upgrade ; terraform apply --auto-approve
```

- Destroy the resources when finished
```bash
terraform destroy --auto-approve
```

See full argument list for each module in use:
  - Google Kubernetes Engine: https://github.com/rancherlabs/tf-rancher-up/tree/main/modules/distribution/gke
