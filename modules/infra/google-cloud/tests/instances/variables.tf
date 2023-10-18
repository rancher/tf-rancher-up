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
  description = "Google Region to create the resources"
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

variable "instance_count" {
  default     = 2
  description = "The number of nodes"
}

variable "startup_script" {
  description = "Script that will run when the VMs start"
  default     = "export DEBIAN_FRONTEND=noninteractive ; curl -sSL https://releases.rancher.com/install-docker/20.10.sh | sh - ; sudo usermod -aG docker ubuntu ; newgrp docker ; sudo sysctl -w net.bridge.bridge-nf-call-iptables=1 ; sleep 180"
}
