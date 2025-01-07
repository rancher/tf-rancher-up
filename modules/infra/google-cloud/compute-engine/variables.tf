variable "prefix" {
  description = "The prefix used in front of all Google resources"
  type        = string
}

variable "project_id" {
  description = "The ID of the Google Project that will contain all created resources"
  type        = string
}

variable "region" {
  description = "Google Region to create the resources"
  type        = string
  default     = "us-west2"

  validation {
    condition = contains([
      "asia-east1",
      "asia-east2",
      "asia-northeast1",
      "asia-northeast2",
      "asia-northeast3",
      "asia-south1",
      "asia-south2",
      "asia-southeast1",
      "asia-southeast2",
      "australia-southeast1",
      "australia-southeast2",
      "europe-central2",
      "europe-north1",
      "europe-southwest1",
      "europe-west1",
      "europe-west10",
      "europe-west12",
      "europe-west2",
      "europe-west3",
      "europe-west4",
      "europe-west6",
      "europe-west8",
      "europe-west9",
      "me-central1",
      "me-central2",
      "me-west1",
      "northamerica-northeast1",
      "northamerica-northeast2",
      "southamerica-east1",
      "southamerica-west1",
      "us-central1",
      "us-east1",
      "us-east4",
      "us-east5",
      "us-south1",
      "us-west1",
      "us-west2",
      "us-west3",
      "us-west4",
    ], var.region)
    error_message = "Invalid Region specified!"
  }
}

variable "create_ssh_key_pair" {
  description = "Specify if a new SSH key pair needs to be created for the instances"
  type        = bool
  default     = true
}

variable "ssh_private_key_path" {
  description = "The full path where is present the pre-generated SSH PRIVATE key (not generated by Terraform)"
  type        = string
  default     = null
}

variable "ssh_public_key_path" {
  description = "The full path where is present the pre-generated SSH PUBLIC key (not generated by Terraform)"
  type        = string
  default     = null
}

variable "ip_cidr_range" {
  description = "Range of private IPs available for the Google Subnet"
  type        = string
  default     = "10.10.0.0/24"
}

variable "create_vpc" {
  description = "Specify whether VPC / Subnet should be created for the instances"
  type        = bool
  default     = true
}

variable "vpc" {
  description = "Google VPC used for all resources"
  type        = string
  default     = null
}

variable "subnet" {
  description = "Google Subnet used for all resources"
  type        = string
  default     = null
}

variable "create_firewall" {
  description = "Google Firewall used for all resources"
  type        = bool
  default     = true
}

variable "instance_count" {
  description = "The number of nodes"
  type        = number
  default     = 3
}

variable "instance_disk_size" {
  description = "Size of the disk attached to each node, specified in GB"
  type        = number
  default     = 50
}

variable "disk_type" {
  description = "Type of the disk attached to each node (e.g. 'pd-standard', 'pd-ssd' or 'pd-balanced')"
  type        = string
  default     = "pd-balanced"
}

variable "instance_type" {
  description = "The name of a Google Compute Engine machine type"
  type        = string
  default     = "n2-standard-2"
}

variable "os_type" {
  description = "Operating system type (sles or ubuntu)"
  type        = string
  default     = "sles"

  validation {
    condition     = contains(["sles", "ubuntu"], var.os_type)
    error_message = "The operating system type must be 'sles' or 'ubuntu'."
  }
}

variable "os_image" {
  description = "Operating system image name"
  type        = string
  default     = "projects/suse-cloud/global/images/sles-15-sp5-v20240913-x86-64"
}

variable "ssh_username" {
  description = "Username used for SSH login"
  type        = string
  default     = "sles"
}

variable "startup_script" {
  description = "Custom startup script"
  type        = string
  default     = null
}
