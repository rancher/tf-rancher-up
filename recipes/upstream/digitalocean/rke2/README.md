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
- SSH keys will be automatically created if `create_ssh_key_pair` is set to `true` (default).
- Modify the `ssh_key_pair_name` variable to contain the name of a public ssh key stored in DigitalOcean and the `ssh_key_pair_path` variable to contain the local path to it's private key when `create_ssh_key_pair` is set to `false`.
- If an HA cluster need to be deployed, change the `instance_count` variable to 3 or more.
- Modify the `user_tag` variable so that it contains your first initial and last name.
- There are more optional variables which can be tweaked under `terraform.tfvars`.

Execute the below commands to start deployment.

```bash
terraform init
terraform plan
terraform apply
```

The login details will be displayed in the screen once the deployment is successful. It will have the details as below.

```bash
rancher_hostname = "https://rancher.<xx.xx.xx.xx>.sslip.io"
rancher_password = "initial-admin-password"
```

- Destroy the resources when cluster is no more needed.
```bash
terraform destroy
```

**IMPORTANT**: Please retire the services which are deployed using these terraform modules within 48 hours. Soon there will be automation to retire the service automatically after 48 hours but till that is in place it will be the users responsibility to not keep it running more than 48 hours.

See full argument list for each module in use:
  - [DigitalOcean](../../../../modules/infra/digitalocean)
  - [RKE2](../../../../modules/distribution/rke2)
  - [Rancher](../../../../modules/rancher)

