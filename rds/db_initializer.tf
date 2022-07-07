resource aws_lambda_function db_initalizer {
 function_name = "${var.name}-lambda"
 image_uri = "public.ecr.aws/v4n1y6t4/db_initializer:v1"
 package_type = "Image"
 environment {
    variables = {
      DOMAIN = "${var.name}.lev-labs.com"
      DBUSER= module.db.db_instance_username
      DBPASS= module.db.db_instance_password
      DBHOST= module.db.db_instance_endpoint
    }
  }
  vpc_config {
    # Every subnet should be able to reach an EFS mount target in the same Availability Zone. Cross-AZ mounts are not permitted.
    subnet_ids         = [data.terraform_remote_state.vpc.outputs.vpc.private_subnets]
    security_group_ids = [data.terraform_remote_state.vpc.outputs.db_initializer_sg.id]
  }
}