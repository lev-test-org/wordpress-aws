resource "tfe_workspace" "wordpress-vpc" {
  name         = "wordpress-vpc"
  organization = "TeraSky"
  tag_names    = ["lev","wordpress-aws"]
  auto_apply = true
  trigger_prefixes = ["vpc"]
  working_directory = "vpc"
  vcs_repo = {
    identifier = "andel7/aws-wordpress"
    branch = "new_features"
    oauth_token_id = "ot-V5uTyGKzPXanNBBe"
  }
}
resource "tfe_workspace" "wordpress-rds" {
  name         = "wordpress-rds"
  organization = "TeraSky"
  tag_names    = ["lev","wordpress-aws"]
  auto_apply = true
  trigger_prefixes = ["rds"]
  working_directory = "rds"
  vcs_repo = {
    identifier = "andel7/aws-wordpress"
    branch = "new_features"
    oauth_token_id = "ot-V5uTyGKzPXanNBBe"
  }
}
resource "tfe_workspace" "wordpress-compute" {
  name         = "wordpress-compute"
  organization = "TeraSky"
  tag_names    = ["lev","wordpress-aws"]
  auto_apply = true
  trigger_prefixes = ["wordpress-compute"]
  working_directory = "wordpress-compute"
  vcs_repo = {
    identifier = "andel7/aws-wordpress"
    branch = "new_features"
    oauth_token_id = "ot-V5uTyGKzPXanNBBe"
  }
}