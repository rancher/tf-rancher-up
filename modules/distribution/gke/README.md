# Terraform | GKE

Terraform modules to provide a Google Kubernetes Engine.

Documentation can be found [here](./docs.md).

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
