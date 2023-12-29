# Terraform | RKE Cluster

Terraform module to create an RKE cluster. It supports single and HA cluster configurations.

Documentation can be found [here](./docs.md).

### Usage

#### Single node cluster

Example uses a specific key file for SSH access

```hcl
module "rke" {
  source = "git::https://github.com/rancherlabs/tf-rancher-up.git//modules/distribution/rke"

  node_public_ip = "192.168.236.121"
  node_username = "ubuntu"
  ssh_private_key_path = "~/.ssh/id_rsa"
}
```

#### HA cluster

Example uses the ssh agent for SSH access

```hcl
module "rke" {
  source = "git::https://github.com/rancherlabs/tf-rancher-up.git//modules/distribution/rke"

  rancher_nodes = [
    {
      public_ip = "192.168.236.121",
      private_ip = "192.168.236.121",
      roles = ["etcd", "controlplane", "worker"]
    },
    {
      public_ip = "192.168.236.122",
      private_ip = "192.168.236.122",
      roles = ["etcd", "controlplane", "worker"]
    },
    {
      public_ip = "192.168.236.123",
      private_ip = "192.168.236.123",
      roles = ["etcd", "controlplane", "worker"]
    }
  ]

  ssh_agent_auth = true
}
```
