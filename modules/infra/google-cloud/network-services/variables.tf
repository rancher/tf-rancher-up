variable "resources_prefix" {}

variable "region" {}

variable "ip_cidr_range" {
  type    = string
  default = "10.10.0.0/24"
}
