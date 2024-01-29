variable "prefix" {
  description = "The prefix used in front of all Google resources"
}

variable "project_id" {
  description = "The ID of the Google Project that will contain all created resources"
}

variable "region" {
  description = "Google Region to create the resources"
}

variable "ip_cidr_range" {
  type        = string
  default     = "10.10.0.0/24"
  description = "Range of private IPs available for the Google Subnet"
}

variable "vpc" {
  description = "Google VPC used for all resources"
  default     = null
}

variable "subnet" {
  description = "Google Subnet used for all resources"
  default     = null
}

variable "cluster_version" {
  default     = "1.26.13-gke.1052000"
  description = "Supported Google Kubernetes Engine for Rancher Manager"
}

variable "instance_count" {
  default     = 1
  description = "The number of nodes per instance group"
}

variable "instance_disk_size" {
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

variable "instance_type" {
  default     = "e2-highmem-2"
  description = "The name of a Google Compute Engine machine type"
}

variable "kube_config_path" {
  description = "The path to write the kubeconfig for the RKE cluster"
  type        = string
  default     = null
}

variable "kube_config_filename" {
  description = "Filename to write the kube config"
  type        = string
  default     = null
}
