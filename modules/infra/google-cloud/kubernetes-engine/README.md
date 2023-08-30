# Terraform | Google Cloud

Terraform modules to provide a Google Kubernetes Engine.

## Example

#### Launch managed Kubernetes cluster with three worker nodes (one per zone)

```terraform
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.75.0"
    }
  }

  required_version = ">= 0.14"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

variable "resources_prefix" {
  type    = string
  default = "example-rancher"
}

variable "project_id" {
  default = "<PROJECT_ID>"

  validation {
    condition     = var.project_id != "<PROJECT_ID>"
    error_message = "Remember to replace the default value of the variable."
  }
}

variable "region" {
  default = "<REGION>"

  validation {
    condition     = var.region != "<REGION>"
    error_message = "Remember to replace the default value of the variable."
  }
}

variable "vpc" {
  type    = string
  default = "<VPC_NAME>"

  validation {
    condition     = var.vpc != "<VPC_NAME>"
    error_message = "Remember to replace the default value of the variable."
  }
}

variable "subnet" {
  type    = string
  default = "<SUBNET_NAME>"

  validation {
    condition     = var.subnet != "<SUBNET_NAME>"
    error_message = "Remember to replace the default value of the variable."
  }
}

module "google-kubernetes-engine" {
  source           = "git::https://github.com/rancherlabs/tf-rancher-up.git//modules/infra/google-cloud/kubernetes-engine"
  resources_prefix = var.resources_prefix
  project_id       = var.project_id
  region           = var.region
  vpc              = var.vpc
  subnet           = var.subnet
}
```

#### Launch managed Kubernetes cluster with three worker nodes (one per zone) and a dedicated new VPC/Subnet

```terraform
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.75.0"
    }
  }

  required_version = ">= 0.14"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

variable "resources_prefix" {
  type    = string
  default = "example-rancher"
}

variable "project_id" {
  default = "<PROJECT_ID>"

  validation {
    condition     = var.project_id != "<PROJECT_ID>"
    error_message = "Remember to replace the default value of the variable."
  }
}

variable "region" {
  default = "<REGION>"

  validation {
    condition     = var.region != "<REGION>"
    error_message = "Remember to replace the default value of the variable."
  }
}

module "google-network-services" {
  source           = "git::https://github.com/rancherlabs/tf-rancher-up.git//modules/infra/google-cloud/network-services"
  resources_prefix = var.resources_prefix
  region           = var.region
}

module "google-kubernetes-engine" {
  source           = "git::https://github.com/rancherlabs/tf-rancher-up.git//modules/infra/google-cloud/kubernetes-engine"
  resources_prefix = var.resources_prefix
  project_id       = var.project_id
  region           = var.region
  vpc              = module.google-network-services.vpc_name
  subnet           = module.google-network-services.subnet_name
}
```

Take a look [here](../tests/gke/).

---

## Requirements

| Name | Version |
|------|---------|
| <a name="required_tf_version"></a> [terraform](#requirement\_terraform) | >= 0.14 |

## Providers

| Name | Version |
|------|---------|
| <a name="required_provider_version"></a> [google](#provider\_google) | 4.75.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google\_compute\_network.vpc](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) | resource |
| [google\_compute\_subnetwork.subnet](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google\_container\_cluster.primary](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster) | resource |
| [google\_container\_node\_pool.primary\_nodes](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |
| []() | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="resources_prefix"></a> [resources\_prefix](#resources\_prefix) | The prefix used in front of all Google resources | `string` | `null` | yes |
| <a name="region"></a> [region](#region) | Google Region used for all resources | `string` | `null` | yes |
| <a name="ip_cidr_range"></a> [ip\_cidr\_range](#ip\_cidr\_range) | The IP range used by the Google Subnet | `string` | `"10.10.0.0/24"` | no |
| <a name="project_id"></a> [project\_id](#project\_id) | The ID of the Google Project that will contain all created resources | `string` | `null` | yes |
| <a name="vpc"></a> [vpc](#vpc) | Google VPC used for all resources | `string` | `null` | yes |
| <a name="subnet"></a> [subnet](#subnet) | Google Subnet used for all resources | `string` | `null` | yes |
| <a name="cluster_version"></a> [cluster\_version](#cluster\_version) | [Supported Google Kubernetes Engine for Rancher Manager](https://www.suse.com/suse-rancher/support-matrix/all-supported-versions/rancher-v2-7-5/) | `string` | `"1.26.7-gke.500"` | no |
| <a name="node_count"></a> [node\_count](#node\_count) | The number of nodes per instance group | `number` | `1` | no |
| <a name="disk_size_gb"></a> [disk\_size\_gb](#disk\_size\_gb) | Size of the disk attached to each node, specified in GB | `number` | `50` | no |
| <a name="disk_type"></a> [disk\_type](#disk\_type) | Type of the disk attached to each node (e.g. 'pd-standard', 'pd-ssd' or 'pd-balanced') | `string` | `"pd-balanced"` | no |
| <a name="image_type"></a> [image\_type](#image\_type) | The default image type used by NAP once a new node pool is being created. The value must be one of the [COS\_CONTAINERD, COS, UBUNTU\_CONTAINERD, UBUNTU]. NOTE: COS AND UBUNTU are deprecated as of GKE 1.24 | `string` | `"cos_containerd"` | no |
| <a name="machine_type"></a> [machine\_type](#machine\_type) | The name of a Google Compute Engine machine type | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="vpc_name"></a> [vpc\_name](#vpc\_name) | n/a |
| <a name="subnet_name"></a> [subnet\_name](#subnet\_name) | n/a |
