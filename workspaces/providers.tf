terraform {
    backend "remote" {
    organization = "TeraSky"
      workspaces {
        name = "wordpress-aws-workspaces"
      }
    }
  required_providers {
    tfe = {
      version = "~> 0.30.2"
    }
  }
}
