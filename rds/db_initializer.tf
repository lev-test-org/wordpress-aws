resource aws_lambda_function db_initalizer {
 function_name = "${var.name}-lambda"
 image_uri = "572445141948.dkr.ecr.eu-west-1.amazonaws.com/db_initializer:v1"
 package_type = "Image"
 role          = aws_iam_role.iam_for_lambda.arn
 environment {
    variables = {
      DOMAIN = "${var.name}.lev-labs.com"
      DBUSER= module.db.db_instance_username
      DBPASS= module.db.db_instance_password
      DBHOST= module.db.db_instance_endpoint
      DBNAME= module.db.db_instance_name
    }
  }
  vpc_config {
    subnet_ids         = data.terraform_remote_state.vpc.outputs.vpc.private_subnets
    security_group_ids = [data.terraform_remote_state.vpc.outputs.db_initializer_sg.id]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "${var.name}-iam_for_lambda"

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

resource "aws_iam_policy" "lambda_logging" {
  name        = "${var.name}-lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_iam_role_policy_attachment" "lambda_vpc" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

data "aws_lambda_invocation" "trigger_db_init" {
  function_name = aws_lambda_function.db_initalizer.function_name

  input = <<JSON
{
  "key1": "value1"
}
JSON
}