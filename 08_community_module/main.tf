provider "aws" {
  region  = "us-east-1"
  profile = "personal"
}

data "archive_file" "main" {
  type        = "zip"
  source_file = "lambda.py"
  output_path = "lambda.zip"
}

module "lambda_scheduled" {
  source              = "github.com/terraform-community-modules/tf_aws_lambda_scheduled"
  lambda_name         = "my_scheduled_lambda"
  runtime             = "python2.7"
  lambda_zipfile      = "lambda.zip"
  source_code_hash    = "${data.archive_file.main.output_base64sha256}"
  handler             = "lambda.handler"
  schedule_expression = "rate(1 minute)"

  iam_policy_document = <<DOC
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
DOC
}
