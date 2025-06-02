# Upstream | Azure | Virtual Machines x K3s

This module is used to establish a Rancher (local) managment cluster using [Azure Virtual Machine](https://learn.microsoft.com/en-us/azure/virtual-machines/) and [K3s](https://docs.k3s.io/).

## Usage

```bash
git clone https://github.com/rancherlabs/tf-rancher-up.git
cd recipes/upstream/azure/k3s
```

- Copy `./terraform.tfvars.exmaple` to `./terraform.tfvars`
- Edit `./terraform.tfvars`
  - Update the required variables:
    -  `prefix` to give the resources an identifiable name (eg, your initials or first name)
    -  `subscription_id` to specify in which Project the resources will be created
    -  `region` to suit your region
    -  `server_instance_count` to specify the number of Server instances to create (to maintain ETCD quorum, the value must be 1, 3, or 5)
    -  `worker_instance_count` to specify the number of Worker instances to create
    -  `instance_type` to specify the instance type used to create Azure Virtual machines (default "Standard_D2_v5")
    -  `os_type` to specify the OS and the SSH user used to create the VMs (default "sles")
    -  `rancher_hostname` in order to reach the Rancher console via DNS name
    -  `rancher_password` to configure the initial Admin password (the password must be at least 12 characters)
- Make sure you are logged into your Azure Account from your local Terminal. See the preparatory steps [here](../../../../modules/infra/azure/README.md).

#### Terraform Apply

```bash
terraform init -upgrade && terraform apply -auto-approve
```

#### Terraform Destroy

```bash
terraform destroy -auto-approve
```

See full argument list for each module in use:
  - Azure Virtual Machine: https://github.com/rancherlabs/tf-rancher-up/tree/main/modules/infra/azure/virtual-machine
  - K3s: https://github.com/rancherlabs/tf-rancher-up/tree/main/modules/distribution/k3s
  - Rancher: https://github.com/rancherlabs/tf-rancher-up/tree/main/modules/rancher
