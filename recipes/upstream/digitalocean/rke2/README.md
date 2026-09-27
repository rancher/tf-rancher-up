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
    -  `prefix` to give the resources an identifiable name (eg, your initials or first name). It must be lowercase letters, digits and `-`, as it becomes part of the Kubernetes node names, and unique in the DigitalOcean account (VPC names are account-wide). Use a different prefix from any downstream recipe.
    -  `do_token` to specify the token to authenticate on DigitalOcean API.
    -  `rancher_password` to specify admin password to access rancher.
  - Optionally set `user_tag` to your name; it is applied as the `user:` tag on every droplet (defaults to `prefix`).
- Variable `os_type` defines operating system used by DigitalOcean droplets. it is possible to choose between `ubuntu` or `opensuse` but, by default, the variable is defined as `opensuse`
- Define variable `droplet_image` with the name of the OpenSUSE image uploaded to the DigitalOcean account when `os_type` has been defined as `opensuse`. The validated OpenSUSE image is openSUSE-Leap-15.6-Minimal-VM.x86_64-Cloud that can be downloaded [here](https://download.opensuse.org/distribution/leap/15.6/appliances/openSUSE-Leap-15.6-Minimal-VM.x86_64-Cloud.qcow2). The steps to upload an image to Digitalocean can be found [here](https://docs.digitalocean.com/products/custom-images/how-to/upload/). 
- SSH keys are automatically created unless you define variable `create_ssh_key_pair` as `false`. A generated key is removed from DigitalOcean on `terraform destroy`.
- Modify the `ssh_key_pair_name` variable to contain the name of a public ssh key stored in DigitalOcean and the `ssh_key_pair_path` variable to contain the local path to it's private key when `create_ssh_key_pair` is set to `false`. The private key must not have a passphrase; Terraform's SSH connections cannot use it otherwise.
- If an HA cluster need to be deployed, change the `droplet_count` variable to 3 or 5. Every node runs etcd, so the count must be 1 or an odd number.
- There are more optional variables which can be tweaked under `terraform.tfvars`.

Terraform 1.9 or later is required.

Execute the below commands to start deployment.

#### Terraform Apply

```bash
terraform init -upgrade && terraform apply -auto-approve
```

#### Terraform Destroy

If a downstream recipe is registered to this Rancher, destroy it first; its destroy needs Rancher to be reachable.

```bash
terraform destroy -auto-approve
```

The login details will be displayed in the screen once the deployment is successful. Log in as `admin` with the `rancher_password` from `terraform.tfvars`.

```bash
rancher_url = "https://rancher.<xx.xx.xx.xx>.sslip.io"
```

Other outputs include the node IPs, `ssh_username`, `ssh_private_key_path` and `kube_config_path` (the kubeconfig of the Rancher cluster).

## Networking

All droplets are placed in one VPC created by the recipe (`<prefix>-vpc`), and RKE2 uses the VPC addresses for node-to-node traffic. Canal's overlay network is pinned to the VPC interface (`private_network_interface`, default `eth1`). With `create_firewall = true`, the firewall allows all traffic within the VPC and only SSH, 443, 6443 and 9345 from outside.

## Audit logging

Two audit logs can be enabled; both are off by default.

- **Rancher API audit log** (UI actions, API calls and kubectl through Rancher's proxy): set `rancher_audit_log_level` to `1` (metadata), `2` (+ request bodies) or `3` (+ response bodies). `rancher_audit_log_destination` is `sidecar` (read with `kubectl logs -c rancher-audit-log`) or `hostPath` (files under `rancher_audit_log_host_path` on the nodes running Rancher). Rotation is set with `rancher_audit_log_max_age`, `rancher_audit_log_max_backup` and `rancher_audit_log_max_size`. Do not set `auditLog.*` through `rancher_additional_helm_values`.
- **Kubernetes API audit log of the Rancher (local) cluster** (access that bypasses Rancher, such as the RKE2 admin kubeconfig): set `kube_audit_level` to `Metadata`, `Request` or `RequestResponse`, or provide a full policy in `kube_audit_policy`. Secrets, ConfigMaps and token reviews are always logged at `Metadata`. The log is written to `/var/lib/rancher/rke2/server/logs/audit.log` on each node. The policy is applied at first boot, so changing it rebuilds the nodes.

The `rancher_audit_log_command` and `kube_audit_log_command` outputs show how to read each log.

## Deploying Downstream Clusters

This recipe **only** deploys the upstream (local) Rancher management cluster. Once it is running, use a downstream recipe to provision workload clusters and register them into Rancher. [recipes/downstream/digitalocean/rke2](../../../downstream/digitalocean/rke2) reads the `rancher_url` and `rancher_token` outputs directly from this recipe's `terraform.tfstate`, so no credentials need to be copied.

See full argument list for each module in use:
  - [DigitalOcean](../../../../modules/infra/digitalocean)
  - [RKE2](../../../../modules/distribution/rke2)
  - [Rancher](../../../../modules/rancher)
