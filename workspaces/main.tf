module "workspaces" {
  source  = "app.terraform.io/TeraSky/workspaces/wordpress"
  version = "0.0.1"
  vpc_cidr = var.vpc_cidr
  owner = var.owner
  name = var.name
  organization = var.organization
  tfe_tags = var.tfe_tags
  branch = var.branch
  env = var.env
}