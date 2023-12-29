# Terraform | Google Compute Engine

Terraform modules to provide VM instances - Google Compute Engine.

Documentation can be found [here](./docs.md).

## Example

#### Launch three identical VM instances (one per zone)

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

variable "prefix" {
  type    = string
  default = "example-rancher"
}

variable "project_id" {
  type    = string
  default = "<PROJECT_ID>"

  validation {
    condition     = var.project_id != "<PROJECT_ID>"
    error_message = "Remember to replace the default value of the variable."
  }
}

variable "region" {
  type    = string
  default = "<REGION>"

  validation {
    condition     = var.region != "<REGION>"
    error_message = "Remember to replace the default value of the variable."
  }
}

variable "instance_count" {
  default     = 3
  description = "The number of nodes"
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

module "google-compute-engine" {
  source         = "../../compute-engine"
  prefix         = var.prefix
  project_id     = var.project_id
  region         = var.region
  instance_count = var.instance_count
  vpc            = var.vpc
  subnet         = var.subnet
}
```

#### Launch two identical VM instances (one per zone) and a dedicated new VPC/Subnet

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

variable "prefix" {
  type    = string
  default = "example-rancher"
}

variable "project_id" {
  type    = string
  default = "<PROJECT_ID>"

  validation {
    condition     = var.project_id != "<PROJECT_ID>"
    error_message = "Remember to replace the default value of the variable."
  }
}

variable "region" {
  type    = string
  default = "<REGION>"

  validation {
    condition     = var.region != "<REGION>"
    error_message = "Remember to replace the default value of the variable."
  }
}

variable "instance_count" {
  default     = 3
  description = "The number of nodes"
}

module "google-compute-engine" {
  source         = "../../compute-engine"
  prefix         = var.prefix
  project_id     = var.project_id
  region         = var.region
  instance_count = var.instance_count
}
```
