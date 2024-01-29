variable "prefix" {
  default = "gke-test"
}

variable "project_id" {
  default = "project-test"
}

variable "region" {
  default = "us-west2"
}

variable "instance_count" {
  default = "3"
}

variable "create_ssh_key_pair" {
  type    = bool
  default = false
}

variable "startup_script" {
  default = "export DEBIAN_FRONTEND=noninteractive ; curl -sSL https://releases.rancher.com/install-docker/20.10.sh | sh - ; sudo usermod -aG docker ubuntu ; newgrp docker ; sudo sysctl -w net.bridge.bridge-nf-call-iptables=1 ; sleep 180"
}
