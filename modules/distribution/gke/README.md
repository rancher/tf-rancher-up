# Terraform | GKE

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

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }

  required_version = ">= 0.14"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "kubernetes" {
  config_path = "./${var.prefix}_kube_config.yml"
}

variable "prefix" {
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
  source     = "../../../../distribution/gke"
  prefix     = var.prefix
  project_id = var.project_id
  region     = var.region
  vpc        = var.vpc
  subnet     = var.subnet
}

resource "null_resource" "first-setup" {
  depends_on = [module.google-kubernetes-engine.kubernetes_cluster_node_pool]
  provisioner "local-exec" {
    command = "sh ./first-setup.sh"
  }
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

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }

  required_version = ">= 0.14"
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "kubernetes" {
  config_path = "./${var.prefix}_kube_config.yml"
}

variable "prefix" {
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

module "google-kubernetes-engine" {
  source     = "../../../../distribution/gke"
  prefix     = var.prefix
  project_id = var.project_id
  region     = var.region
}

resource "null_resource" "first-setup" {
  depends_on = [module.google-kubernetes-engine.kubernetes_cluster_node_pool]
  provisioner "local-exec" {
    command = "sh ./first-setup.sh"
  }
}
```

Take a look [here](../../infra/google-cloud/tests/gke).

---

## Requirements

| Name | Version |
|------|---------|
| <a name="required_tf_version"></a> [terraform](#requirement\_terraform) | >= 0.14 |

## Providers

| Name | Version |
|------|---------|
| <a name="required_google_provider_version"></a> [google](#provider\_google) | 4.75.0 |
| <a name="required_k8s_provider_version"></a> [kubernetes](#provider\_kubernetes) | >= 2.0.0 |
| <a name="required_helm_provider_version"></a> [helm](#provider\_helm) | >= 2.10.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google\_container\_cluster.primary](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster) | resource |
| [google\_container\_node\_pool.primary\_nodes](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="prefix"></a> [prefix](#prefix) | The prefix used in front of all Google resources | `string` | `null` | yes |
| <a name="region"></a> [region](#region) | Google Region used for all resources | `string` | `null` | yes |
| <a name="ip_cidr_range"></a> [ip\_cidr\_range](#ip\_cidr\_range) | The IP range used by the Google Subnet | `string` | `"10.10.0.0/24"` | no |
| <a name="project_id"></a> [project\_id](#project\_id) | The ID of the Google Project that will contain all created resources | `string` | `null` | yes |
| <a name="vpc"></a> [vpc](#vpc) | Google VPC used for all resources | `string` | `null` | yes |
| <a name="subnet"></a> [subnet](#subnet) | Google Subnet used for all resources | `string` | `null` | yes |
| <a name="cluster_version"></a> [cluster\_version](#cluster\_version) | [Supported Google Kubernetes Engine for Rancher Manager](https://www.suse.com/suse-rancher/support-matrix/all-supported-versions/rancher-v2-7-5/) | `string` | `"1.26.7-gke.500"` | no |
| <a name="instance_count"></a> [instance\_count](#instance\_count) | The number of nodes per instance group | `number` | `1` | no |
| <a name="instance_disk_size"></a> [instance\_disk\_size](#instance\_disk\_size) | Size of the disk attached to each node, specified in GB | `number` | `50` | no |
| <a name="disk_type"></a> [disk\_type](#disk\_type) | Type of the disk attached to each node (e.g. 'pd-standard', 'pd-ssd' or 'pd-balanced') | `string` | `"pd-balanced"` | no |
| <a name="image_type"></a> [image\_type](#image\_type) | The default image type used by NAP once a new node pool is being created. The value must be one of the [COS\_CONTAINERD, COS, UBUNTU\_CONTAINERD, UBUNTU]. NOTE: COS AND UBUNTU are deprecated as of GKE 1.24 | `string` | `"cos_containerd"` | no |
| <a name="instance_type"></a> [instance\_type](#instance\_type) | The name of a Google Compute Engine machine type | `string` | `"e2-highmem-2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="kubernetes_cluster_name"></a> [kubernetes\_cluster\_name](#kubernetes\_cluster\_name) | n/a |
| <a name="kubernetes_cluster_host"></a> [kubernetes\_cluster\_host](#kubernetes\_cluster\_host) | n/a |
| <a name="kubernetes_cluster_node_pool"></a> [kubernetes\_cluster\_node\_pool](#kubernetes\_cluster\_node\_pool) | n/a |
