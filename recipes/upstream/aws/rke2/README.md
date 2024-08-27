# Upstream | AWS | EC2 x RKE2

This module is used to establish a Rancher (local) management cluster using [AWS EC2](https://aws.amazon.com/ec2/) and [RKE2](https://docs.rke2.io/).

Documentation can be found [here](./docs.md).

## Usage

```bash
git clone https://github.com/rancherlabs/tf-rancher-up.git
cd recipes/upstream/aws/rke2
```

- Copy `./terraform.tfvars.exmaple` to `./terraform.tfvars`
- Edit `./terraform.tfvars`
  - Update the required variables:
    -  `prefix` to give the resources an identifiable name (eg, your initials or first name)
    -  `aws_region` to suit your region
    -  `instance_count` to specify the number of instances to create
    -  `rancher_hostname` in order to reach the Rancher console via DNS name
    -  `rancher_password` to configure the initial Admin password (the password must be at least 12 characters)
- Make sure you are logged into your AWS Account from your local Terminal. See the preparatory steps [here](../../../../modules/infra/aws/README.md).

**NB: If you want to use all the configurable variables in the `terraform.tfvars` file, you will need to uncomment them there and in the `variables.tf` and `main.tf` files.**

```bash
terraform init -upgrade && terraform apply -auto-approve
```

- Destroy the resources when finished
```bash
terraform destroy -auto-approve
```

See full argument list for each module in use:
  - AWS EC2: https://github.com/rancher/tf-rancher-up/tree/main/modules/infra/aws/ec2
  - RKE2: https://github.com/rancher/tf-rancher-up/tree/main/modules/distribution/rke2
  - Rancher: https://github.com/rancher/tf-rancher-up/tree/main/modules/rancher
