# Downstream | DigitalOcean | RKE2

This module is used to create a custom RKE2 downstream cluster on DigitalOcean droplets and register it to an existing Rancher server.

Documentation can be found [here](./docs.md).

## Usage

```bash
git clone https://github.com/rancherlabs/tf-rancher-up.git
cd recipes/downstream/digitalocean/rke2
```

- Copy `terraform.tfvars.example` to `terraform.tfvars`
- Edit `terraform.tfvars`
  - Update the required variables:
    - `do_token` to specify the token to authenticate on DigitalOcean API.
    - `prefix` to give the resources an identifiable name. It must be lowercase letters, digits and `-`, as it becomes part of the Kubernetes node names, and unique in the DigitalOcean account (VPC names are account-wide). Use a different prefix from the upstream recipe.
  - Rancher connection, one of:
    - **Default:** deploy [recipes/upstream/digitalocean/rke2](../../../upstream/digitalocean/rke2) first. This recipe reads its `rancher_url` and `rancher_token` outputs from `upstream_state_path` (default `../../../upstream/digitalocean/rke2/terraform.tfstate`). Point `upstream_state_path` at another recipe's state file to use a different upstream.
    - **Any other Rancher:** set both `rancher_api_url` and `rancher_token_key` (an API token from the Rancher UI → Profile Icon → Account & API Keys). Set `rancher_insecure = false` if Rancher has a certificate from a trusted CA.
  - Optionally set `cluster_name` (default `do-downstream`), `rke2_version` (must be a version the upstream Rancher offers), `droplet_count` and `user_tag` (your name, applied as the `user:` tag on every droplet).
- Every node runs all roles (etcd, control plane and worker), so `droplet_count` must be 1 or an odd number (3, 5).
- Variable `os_type` defines operating system used by DigitalOcean droplets (`opensuse` or `ubuntu`, default `opensuse`). When it is `opensuse`, `droplet_image` must name an openSUSE image uploaded to the DigitalOcean account, as described in the [upstream recipe](../../../upstream/digitalocean/rke2).
- SSH keys are automatically created unless you define variable `create_ssh_key_pair` as `false`, in which case set `ssh_key_pair_name` (a key already in DigitalOcean) and `ssh_key_pair_path` (its private key, without a passphrase).

Terraform 1.9 or later is required.

Execute the below commands to start deployment.

```bash
terraform init
terraform plan
terraform apply
```

The droplets are registered to Rancher over SSH, and `terraform apply` finishes only when Rancher reports the cluster as active. A kubeconfig for the cluster (proxied through Rancher) is written to `<cluster_name>_kube_config.yml`; see the `kube_config_path` output.

- Destroy the resources when cluster is no more needed. Destroy this recipe before the upstream one; its destroy needs Rancher to be reachable.
```bash
terraform destroy
```

## Networking

All droplets are placed in one VPC created by the recipe (`<prefix>-vpc`). Nodes register with their VPC address as the internal address and their public address as the external one, and Canal's overlay network is pinned to the VPC interface (`private_network_interface`, default `eth1`). With `create_firewall = true`, the firewall allows all traffic within the VPC and only SSH, 443, 6443 and 9345 from outside.

## Audit logging

Set `kube_audit_level` to `Metadata`, `Request` or `RequestResponse` (default `None`), or provide a full policy in `kube_audit_policy`, to enable the Kubernetes API audit log on the control-plane nodes. Secrets, ConfigMaps and token reviews are always logged at `Metadata`. Rancher applies the change by reconfiguring the control-plane nodes one at a time. The log is written to `/var/lib/rancher/rke2/server/logs/audit.log` on each node; the `kube_audit_log_command` output shows how to read it.

This log records requests that never pass through the Rancher API audit log (configured on the upstream recipe):

- Commands run in the Rancher UI kubectl shell. The shell pod calls this cluster's API server directly, impersonating the Rancher user, so entries show `impersonatedUser.username` set to the Rancher user ID.
- kubectl access through the Authorized Cluster Endpoint (below).

## Authorized Cluster Endpoint

Set `authorized_cluster_endpoint = { enabled = true }` to let kubeconfigs downloaded from Rancher reach this cluster's API server directly (one context per control-plane node), which keeps working if Rancher is unavailable. Set `fqdn` and `ca_certs` to use a load balancer instead of the per-node contexts. Requests made this way appear only in this cluster's Kubernetes API audit log.

See full argument list for each module in use:
  - [DigitalOcean](../../../../modules/infra/digitalocean)
