terraform {
  cloud {
    organization = "TeraSky"

    workspaces {
      name = "wordpress-vpc"
    }
  }
}