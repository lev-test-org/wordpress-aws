terraform {
  backend "remote" {}
  required_providers {
    tfe = {
      version = "~> 0.36.0"
    }
  }
}
