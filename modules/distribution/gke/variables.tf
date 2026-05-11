variable "prefix" {
  type        = string
  description = "The prefix used in front of all Google resources"
}

variable "project_id" {
  type        = string
  description = "The ID of the Google Project that will contain all created resources"
}

variable "region" {
  type        = string
  description = "Google Region to create the resources"
  default     = "us-west2"
  validation {
    condition     = contains(data.google_compute_regions.available.names, var.region)
    error_message = "The region '${var.region}' is not available in your GCP project. Valid regions are: ${join(", ", data.google_compute_regions.available.names)}"
  }
}

variable "ip_cidr_range" {
  type        = string
  default     = "10.10.0.0/24"
  description = "Range of private IPs available for the Google Subnet"
}

variable "vpc" {
  type        = string
  description = "Google VPC used for all resources"
  default     = null
}

variable "subnet" {
  type        = string
  description = "Google Subnet used for all resources"
  default     = null
}

variable "cluster_version_prefix" {
  type        = string
  default     = "1.34."
  description = "Supported Google Kubernetes Engine for Rancher Manager"
}

variable "instance_count" {
  type        = number
  default     = 1
  description = "The number of nodes per instance group"
}

variable "instance_disk_size" {
  type        = number
  default     = 50
  description = "Size of the disk attached to each node, specified in GB"
}

variable "disk_type" {
  type        = string
  default     = "pd-balanced"
  description = "Type of the disk attached to each node (e.g. 'pd-standard', 'pd-ssd' or 'pd-balanced')"
}

variable "image_type" {
  type        = string
  default     = "cos_containerd"
  description = "The default image type used by NAP once a new node pool is being created. The value must be one of the [COS_CONTAINERD, COS, UBUNTU_CONTAINERD, UBUNTU]. NOTE: COS AND UBUNTU are deprecated as of GKE 1.24"
}

variable "instance_type" {
  type        = string
  default     = "e2-highmem-2"
  description = "The name of a Google Compute Engine machine type"
}
