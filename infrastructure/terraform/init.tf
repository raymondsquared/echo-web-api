provider "aws" {
  region  = "ap-southeast-2"
  profile = "paw"
}

variable "lambda_function_name" {
  default = "echo-web-api"
}

variable "api_gateway_stage_name" {
  default = "test"
}

locals {
  api_key = "uuid-1-2-3"
}

resource "aws_iam_role" "echo_lambda_role" {
  name               = "echo-lambda-role"
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

resource "aws_cloudwatch_log_group" "echo_lambda_log_group" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 7
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
resource "aws_iam_policy" "echo_logs_policy" {
  name        = "echo-lambda-logs-policy"
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
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams",
        "logs:PutLogEvents",
        "logs:GetLogEvents",
        "logs:FilterLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "echo_lambda_logs" {
  role       = aws_iam_role.echo_lambda_role.name
  policy_arn = aws_iam_policy.echo_logs_policy.arn
}
