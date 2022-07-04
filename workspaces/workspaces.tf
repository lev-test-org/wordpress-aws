resource "tfe_workspace" "wordpress-vpc" {
  name         = "wordpress-vpc"
  organization = "TeraSky"
  tag_names    = ["lev","wordpress-aws"]
  auto_apply = true
  trigger_prefixes = ["vpc"]
  working_directory = "vpc"
  vcs_repo  {
    identifier = "lev-test-org/wordpress-aws"
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
  vcs_repo  {
    identifier = "lev-test-org/wordpress-aws"
    branch = "new_features"
    oauth_token_id = "ot-V5uTyGKzPXanNBBe"
  }
}
resource "tfe_run_trigger" "wordpress-rds-trigger" {
  workspace_id  = tfe_workspace.wordpress-rds.id
  sourceable_id = tfe_workspace.wordpress-vpc.id
}
resource "tfe_workspace" "wordpress-compute" {
  name         = "wordpress-compute"
  organization = "TeraSky"
  tag_names    = ["lev","wordpress-aws"]
  auto_apply = true
  trigger_prefixes = ["wordpress-compute"]
  working_directory = "wordpress-compute"
  vcs_repo  {
    identifier = "lev-test-org/wordpress-aws"
    branch = "new_features"
    oauth_token_id = "ot-V5uTyGKzPXanNBBe"
  }
}
resource "tfe_run_trigger" "wordpress-compute-trigger" {
  workspace_id  = tfe_workspace.wordpress-compute.id
  sourceable_id = tfe_workspace.wordpress-rds.id
}