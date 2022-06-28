data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = "TeraSky"
    workspaces = {
      name = "wordpress-vpc"
    }
  }
}

data "terraform_remote_state" "rds" {
  backend = "remote"

  config = {
    organization = "TeraSky"
    workspaces = {
      name = "wordpress-rds"
    }
  }
}