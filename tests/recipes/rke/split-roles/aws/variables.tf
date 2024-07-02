variable "prefix" {
  default = "ec2-test"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "server_nodes_count" {
  default = 3
}

variable "worker_nodes_count" {
  default = 3
}

variable "ssh_username" {
  default = "ubuntu"
}
