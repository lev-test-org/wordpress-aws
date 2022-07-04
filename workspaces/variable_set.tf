data "tfe_workspace_ids" "all_wordpress" {
  names        = ["*"]
  tag_names = ["wordpress-aws"]
  organization = "TeraSky"
}

resource "tfe_variable_set" "common_vars" {
  name          = "Wordpress vars"
  description   = "Variables shared for multiple workspaces of wordpress project"
  organization  = "TeraSky"
//  workspace_ids = length(data.tfe_workspace_ids.all_wordpress) == 0 ? [""] : [data.tfe_workspace_ids.all_wordpress.ids]
}

resource "tfe_variable" "vpc_cidr" {
  key             = "vpc_cidr"
  value           = "10.0.0.0/16"
  category        = "terraform"
  description     = "cidr of the vpc"
  variable_set_id = tfe_variable_set.common_vars.id
}

resource "tfe_variable" "tags" {
  key             = "tags"
  value           = "{\n \"Terraform\" = \"true\" \n \"Environment\" = \"dev\" \n \"Owner\" = \"Lev\"\n}"
  category        = "terraform"
  description     = "tags for aws resources"
  variable_set_id = tfe_variable_set.common_vars.id
}
resource "tfe_variable" "name" {
  key             = "name"
  value           = "lev-wordpress"
  category        = "terraform"
  description     = "tags for aws resources"
  variable_set_id = tfe_variable_set.common_vars.id
}