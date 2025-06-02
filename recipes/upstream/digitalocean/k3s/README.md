# Upstream | DigitalOcean | K3s

This module is used to establish a Rancher (local) management cluster using DigitalOcean and K3s.

Documentation can be found [here](./docs.md).

## Usage

```bash
git clone https://github.com/rancherlabs/tf-rancher-up.git
cd recipes/upstream/digitalocean/k3s
```

- Copy `terraform.tfvars.example` to `terraform.tfvars`
- Edit `terraform.tfvars`
  - Update the required variables:
    -  `region` to suit your region
    -  `prefix` to give the resources an identifiable name (eg, your initials or first name)
    -  `do_token` to specify the token to authenticate on DigitalOcean API.
    -  `droplet_size` to specify the instance type used to create DigitalOcean Droplets (default "s-2vcpu-4gb")
    -  `server_instance_count` to specify the number of Server instances to create (to maintain ETCD quorum, the value must be 1, 3, or 5)
    -  `worker_instance_count` to specify the number of Worker instances to create
    -  `rancher_hostname` in order to reach the Rancher console via DNS name 
    -  `rancher_password` to specify admin password to access rancher.
- Variable `os_type` defines operating system used by DigitalOcean droplets. it is possible to choose between `ubuntu` or `opensuse` but, by default, the variable is defined as `opensuse`
- Define variable `droplet_image` with the name of the OpenSUSE image uploaded to the DigitalOcean account when `os_type` has been defined as `opensuse`. The validated OpenSUSE image is openSUSE-Leap-15.6-Minimal-VM.x86_64-Cloud that can be downloaded [here](https://download.opensuse.org/distribution/leap/15.6/appliances/openSUSE-Leap-15.6-Minimal-VM.x86_64-Cloud.qcow2). The steps to upload an image to Digitalocean can be found [here](https://docs.digitalocean.com/products/custom-images/how-to/upload/). 

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
  - [k3s](../../../../modules/distribution/k3s)
  - [Rancher](../../../../modules/rancher)

