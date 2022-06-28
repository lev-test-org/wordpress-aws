vpc_cidr = "10.0.0.0/16"
azs = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
tags = {
        Terraform = "true"
        Environment = "dev"
        Owner = "Lev"
      }
name = "wordpress"