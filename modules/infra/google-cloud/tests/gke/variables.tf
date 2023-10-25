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
