# Downstream | DigitalOcean | V2

This recipe is used to create a Rancher-launched RKE2/k3s downstream cluster using the DigitalOcean node driver.

## Usage

```bash
git clone https://github.com/rancherlabs/tf-rancher-up.git
cd recipes/downstream/digitalocean/v2
```

- Copy `terraform.tfvars.example` to `terraform.tfvars`
- Edit `terraform.tfvars`
  - Update the required variables:
    - Recommended: Configure an existing cloud credential ID in Rancher. Alternatively set `do_token`
    - Set the `region`, and a name for the cluster (`cluster_name`)
    - Add the Rancher server URL as well an API token.

Execute the below commands to start deployment.

```bash
terraform init
terraform plan
terraform apply
```

Once the deployment is successful, the terraform code will display the successful creation message.

- Destroy the resources when cluster is no more needed.
```bash
terraform destroy
```

## Multiple machine pools

`machine_pools` is optional. When set, it replaces the legacy `cp_*` and `worker_*` pool settings. Each pool declares its roles explicitly and creates its own machine config. Per-pool `region`, `size`, and `image` fall back to the global values.

## Custom user data

`custom_user_data` is passed to the machine driver `userdata` field (Rancher interprets it).

## Networking and security

This recipe uses DigitalOcean's default networking. Configure a DigitalOcean firewall (targeting the droplet tags) for adequate security. VPC configuration is not handled by the node driver.