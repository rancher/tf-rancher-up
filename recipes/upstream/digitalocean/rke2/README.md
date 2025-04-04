# Upstream | DigitalOcean | RKE2

This module is used to establish a Rancher (local) management cluster using DigitalOcean and RKE2.

Documentation can be found [here](./docs.md).

## Usage

```bash
git clone https://github.com/rancherlabs/tf-rancher-up.git
cd recipes/upstream/digitalocean/rke2
```

- Copy `terraform.tfvars.example` to `terraform.tfvars`
- Edit `terraform.tfvars`
  - Update the required variables:
    -  `region` to suit your region
    -  `prefix` to give the resources an identifiable name (eg, your initials or first name)
    -  `do_token` to specify the token to authenticate on DigitalOcean API.
    -  `user_tag` To specify the tag associated to the resources on DigitalOcean.
    -  `rancher_password` to specify admin password to access rancher.
- SSH keys are automatically created unless you define variable `create_ssh_key_pair` as `false`.
- Modify the `ssh_key_pair_name` variable to contain the name of a public ssh key stored in DigitalOcean and the `ssh_key_pair_path` variable to contain the local path to it's private key when `create_ssh_key_pair` is set to `false`.
- If an HA cluster need to be deployed, change the `droplet_count` variable to 3 or more.
- There are more optional variables which can be tweaked under `terraform.tfvars`.

Execute the below commands to start deployment.

#### Terraform Apply

```bash
terraform init -upgrade && terraform apply -auto-approve
```

#### Terraform Destroy

```bash
terraform destroy -auto-approve
```

The login details will be displayed in the screen once the deployment is successful. It will have the details as below.

```bash
rancher_hostname = "https://rancher.<xx.xx.xx.xx>.sslip.io"
rancher_password = "initial-admin-password"
```


See full argument list for each module in use:
  - [DigitalOcean](../../../../modules/infra/digitalocean)
  - [RKE2](../../../../modules/distribution/rke2)
  - [Rancher](../../../../modules/rancher)

