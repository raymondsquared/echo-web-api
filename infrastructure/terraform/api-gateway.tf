resource "aws_api_gateway_rest_api" "echo_apigw_rest_api" {
  name        = "echo-rest-web-api"
  description = "API Gatewaway for echo web api"
}

resource "aws_api_gateway_resource" "echo_apigw_proxy_resource" {
  rest_api_id = aws_api_gateway_rest_api.echo_apigw_rest_api.id
  parent_id   = aws_api_gateway_rest_api.echo_apigw_rest_api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "echo_apigw_proxy_method" {
  rest_api_id   = aws_api_gateway_rest_api.echo_apigw_rest_api.id
  resource_id   = aws_api_gateway_resource.echo_apigw_proxy_resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "echo_apigw_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.echo_apigw_rest_api.id
  resource_id             = aws_api_gateway_method.echo_apigw_proxy_method.resource_id
  http_method             = aws_api_gateway_method.echo_apigw_proxy_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.echo_lambda_function.invoke_arn
}

resource "aws_api_gateway_method" "echo_apigw_proxy_root_method" {
  rest_api_id   = aws_api_gateway_rest_api.echo_apigw_rest_api.id
  resource_id   = aws_api_gateway_rest_api.echo_apigw_rest_api.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "echo_lambda_root_integration" {
  rest_api_id             = aws_api_gateway_rest_api.echo_apigw_rest_api.id
  resource_id             = aws_api_gateway_method.echo_apigw_proxy_root_method.resource_id
  http_method             = aws_api_gateway_method.echo_apigw_proxy_root_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.echo_lambda_function.invoke_arn
}

resource "aws_api_gateway_deployment" "echo_apigw_deployment" {
  depends_on = [
    aws_api_gateway_integration.echo_lambda_root_integration,
    aws_api_gateway_integration.echo_lambda_root_integration,
  ]

  rest_api_id = aws_api_gateway_rest_api.echo_apigw_rest_api.id
  stage_name  = var.api_gateway_stage_name
}

resource "aws_lambda_permission" "echo_apigw_permission" {
  statement_id  = "api-gateway-permission"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.echo_lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.echo_apigw_rest_api.execution_arn}/*/*"
}
