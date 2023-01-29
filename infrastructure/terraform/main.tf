resource "aws_lambda_layer_version" "echo_node_modules_lambda_layer" {
  filename   = "../base-node-modules-layer.zip"
  layer_name = "echo-node-modules-layer"

  compatible_runtimes = ["nodejs18.x"]
}

resource "aws_lambda_function" "echo_lambda_function" {
  depends_on = [
    aws_iam_role_policy_attachment.echo_lambda_logs,
    aws_cloudwatch_log_group.echo_lambda_log_group,
  ]

  function_name = var.lambda_function_name
  filename      = "../echo-web-api-lambda.zip"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  role          = aws_iam_role.echo_lambda_role.arn

  layers = [
    aws_lambda_layer_version.echo_node_modules_lambda_layer.arn
  ]

  environment {
    variables = {
      API_KEY = local.api_key
    }
  }
}
