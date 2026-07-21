terraform {
  required_version = ">= 1.5.0"
  required_providers {
    ssh = {
      source  = "loafoe/ssh"
      version = ">= 2.7.0"
    }
  }
}