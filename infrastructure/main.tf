provider "aws" {
  region  = "ap-southeast-2"
  profile = "paw"
}

variable "lambda_function_name" {
  default = "echo-web-api-function"
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

resource "aws_cloudwatch_log_group" "echo_log_group" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 7
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
resource "aws_iam_policy" "echo_logs_policy" {
  name        = "echo_lambda_logging"
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

resource "aws_iam_role_policy_attachment" "echo_lambda_logs" {
  role       = aws_iam_role.echo_lambda_role.name
  policy_arn = aws_iam_policy.echo_logs_policy.arn
}

resource "aws_lambda_function" "echo_lambda_function" {
  depends_on = [
    aws_iam_role_policy_attachment.echo_lambda_logs,
    aws_cloudwatch_log_group.echo_log_group,
  ]

  function_name = var.lambda_function_name
  filename      = "lambda.zip"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  role          = aws_iam_role.echo_lambda_role.arn
}

resource "aws_api_gateway_rest_api" "echo_rest_api" {
  name        = "echo-web-api-rest-api"
  description = "Terraform Serverless Application Example"
}

resource "aws_api_gateway_resource" "echo_proxy_resource" {
  rest_api_id = aws_api_gateway_rest_api.echo_rest_api.id
  parent_id   = aws_api_gateway_rest_api.echo_rest_api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "echo_proxy_method" {
  rest_api_id   = aws_api_gateway_rest_api.echo_rest_api.id
  resource_id   = aws_api_gateway_resource.echo_proxy_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "echo_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.echo_rest_api.id
  resource_id             = aws_api_gateway_method.echo_proxy_method.resource_id
  http_method             = aws_api_gateway_method.echo_proxy_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.echo_lambda_function.invoke_arn
}

resource "aws_api_gateway_method" "echo_proxy_root_method" {
  rest_api_id   = aws_api_gateway_rest_api.echo_rest_api.id
  resource_id   = aws_api_gateway_rest_api.echo_rest_api.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "echo_lambda_root_integration" {
  rest_api_id             = aws_api_gateway_rest_api.echo_rest_api.id
  resource_id             = aws_api_gateway_method.echo_proxy_root_method.resource_id
  http_method             = aws_api_gateway_method.echo_proxy_root_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.echo_lambda_function.invoke_arn
}

resource "aws_api_gateway_deployment" "echo_deployment" {
  depends_on = [
    aws_api_gateway_integration.echo_lambda_integration,
    aws_api_gateway_integration.echo_lambda_root_integration,
  ]

  rest_api_id = aws_api_gateway_rest_api.echo_rest_api.id
  stage_name  = "test"
}

resource "aws_lambda_permission" "echo_apigw_permission" {
  statement_id  = "api-gateway-permission"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.echo_lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.echo_rest_api.execution_arn}/*/*"
}
