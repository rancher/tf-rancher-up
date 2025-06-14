# Upstream | Azure | Virtual Machine x RKE2

This module is used to establish a Rancher (local) managment cluster using [Azure Virtual Machine](https://learn.microsoft.com/en-us/azure/virtual-machines/) and [RKE2](https://docs.rke2.io/).

## Usage

```bash
git clone https://github.com/rancherlabs/tf-rancher-up.git
cd recipes/upstream/azure/rke2
```

- Copy `./terraform.tfvars.exmaple` to `./terraform.tfvars`
- Edit `./terraform.tfvars`
  - Update the required variables:
    -  `prefix` to give the resources an identifiable name (eg, your initials or first name)
    -  `subscription_id` to specify in which Azure subscription the resources will be created
    -  `region` to suit your region
    -  `instance_count` to specify the number of instances to create
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
  - RKE2: https://github.com/rancherlabs/tf-rancher-up/tree/main/modules/distribution/rke2
  - Rancher: https://github.com/rancherlabs/tf-rancher-up/tree/main/modules/rancher
