resource aws_lambda_function db_initalizer {
 function_name = "${var.name}-lambda"
 image_uri = "public.ecr.aws/v4n1y6t4/db_initializer:v1"
 package_type = "Image"
 role          = aws_iam_role.iam_for_lambda.arn
 environment {
    variables = {
      DOMAIN = "${var.name}.lev-labs.com"
      DBUSER= module.db.db_instance_username
      DBPASS= module.db.db_instance_password
      DBHOST= module.db.db_instance_endpoint
    }
  }
  vpc_config {
    subnet_ids         = data.terraform_remote_state.vpc.outputs.vpc.private_subnets
    security_group_ids = [data.terraform_remote_state.vpc.outputs.db_initializer_sg.id]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}