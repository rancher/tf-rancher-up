# TEST - Google Cloud Compute Engine VM instances deploy

This directory has code to test the Google Cloud Compute Engine VM instances [module](../../../../modules/infra/google-cloud/compute-engine).

Documentation can be found [here](./docs.md).

## Usage

```bash
git clone https://github.com/rancherlabs/tf-rancher-up.git
cd tests/modules/infra/google-cloud
```

- Copy `./terraform.tfvars.exmaple` to `./terraform.tfvars`
- Edit `./terraform.tfvars`
  - Update the required variables:
    -  `prefix` to give the resources an identifiable name (eg, your initials or first name)
    -  `project_id` to specify in which Project the resources will be created
    -  `region` to suit your region
    -  `instance_count` to specify the number of instances to create
- Make sure you are logged into your Google Account from your local Terminal. See the preparatory steps [here](../../../../modules/infra/google-cloud/README.md).

```bash
terraform init -upgrade ; terraform apply -target=module.google-compute-engine.tls_private_key.ssh_private_key -target=module.google-compute-engine.local_file.private_key_pem -target=module.google-compute-engine.local_file.public_key_pem -auto-approve ; terraform apply -auto-approve
```

- Destroy the resources when finished
```bash
terraform destroy -auto-approve
```

See full argument list for each module in use:
  - Google Compute Engine: https://github.com/rancherlabs/tf-rancher-up/tree/main/modules/infra/google-cloud/compute-engine

## How to log into VMs

```bash
ssh -oStrictHostKeyChecking=no -i <PREFIX>-ssh_private_key.pem ubuntu@<VM_PUBLIC_IP>
```
