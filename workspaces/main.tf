module "workspaces" {
  source  = "app.terraform.io/TeraSky/workspaces/wordpress"
  version = "~> 0.0.19"
  vpc_cidr = var.vpc_cidr
  owner = var.owner
  name = var.name
  organization = var.organization
  tfe_tags = var.tfe_tags
  branch = var.branch
  env = var.env
  cred_var_set = "lev-aws"
}