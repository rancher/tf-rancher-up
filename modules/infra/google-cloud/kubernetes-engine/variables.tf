variable "resources_prefix" {}

variable "project_id" {}

variable "region" {}

variable "vpc" {}

variable "subnet" {}

variable "cluster_version" {
  default     = "1.26.7-gke.500"
  description = "Supported Google Kubernetes Engine for Rancher Manager"
}

variable "node_count" {
  default     = 1
  description = "The number of nodes per instance group"
}

variable "disk_size_gb" {
  default     = 50
  description = "Size of the disk attached to each node, specified in GB"
}

variable "disk_type" {
  default     = "pd-balanced"
  description = "Type of the disk attached to each node (e.g. 'pd-standard', 'pd-ssd' or 'pd-balanced')"
}

variable "image_type" {
  default     = "cos_containerd"
  description = "The default image type used by NAP once a new node pool is being created. The value must be one of the [COS_CONTAINERD, COS, UBUNTU_CONTAINERD, UBUNTU]. NOTE: COS AND UBUNTU are deprecated as of GKE 1.24"
}

variable "machine_type" {
  default     = "e2-highmem-2"
  description = "The name of a Google Compute Engine machine type"
}
