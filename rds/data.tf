data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = "TeraSky"
    workspaces = {
      name = "${var.env}-wordpress-vpc"
    }
  }
}