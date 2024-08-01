# RKE | With split roles | AWS

This module helps to create an RKE cluster with split roles (master, worker) on AWS infrastructure.

Documentation can be found [here](./docs.md).

## Usage

```bash
git clone https://github.com/rancherlabs/tf-rancher-up.git
cd tests/recipes/rke/split-roles/aws
```

- Edit `./variables.tf`
  - Update the required variables (`prefix`, `aws_region`, `server_nodes_count`, `worker_nodes_count`, and `ssh_username`).
- Make sure you are logged into your AWS Account from your local Terminal. See the preparatory steps [here](../../../../../modules/infra/aws/README.md).

```bash
terraform init --upgrade ; terraform apply --auto-approve
```

- Destroy the resources when finished
```bash
terraform destroy --auto-approve

```

See full argument list for each module in use:
  - AWS EC2: https://github.com/rancher/tf-rancher-up/tree/main/modules/infra/aws/ec2
  - RKE: https://github.com/rancher/tf-rancher-up/tree/main/modules/distribution/rke
  - Rancher: https://github.com/rancher/tf-rancher-up/tree/main/modules/rancher
