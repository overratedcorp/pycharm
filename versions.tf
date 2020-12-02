terraform {

  required_providers {
    docker = {
      source  = "terraform-providers/docker"
      version = "~> 2.7.2"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 1.2.0"
    }
  }

  required_version = ">= 0.13.4"
}
