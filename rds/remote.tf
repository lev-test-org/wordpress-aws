terraform {
  cloud {
    organization = "TeraSky"

    workspaces {
      name = "wordpress-rds"
    }
  }
}