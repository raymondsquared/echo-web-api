resource "aws_dynamodb_table" "echo-dynamodb-table" {
  name           = "echo-web-api-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 2
  write_capacity = 2
  hash_key       = "key"

  attribute {
    name = "key"
    type = "S"
  }
}

resource "aws_iam_policy" "echo_dynamodb_policy" {
  name        = "echo-lambda-dynamodb-policy"
  path        = "/"
  description = "IAM policy for accessing DynamoDB from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:BatchGetItem",
        "dynamodb:GetItem",
        "dynamodb:Query",
        "dynamodb:Scan",
        "dynamodb:BatchWriteItem",
        "dynamodb:PutItem"
      ],
      "Resource": "arn:aws:dynamodb:ap-southeast-2:583774007388:table/echo-web-api-table",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "echo_lambda_dynamodb" {
  role       = aws_iam_role.echo_lambda_role.name
  policy_arn = aws_iam_policy.echo_dynamodb_policy.arn
}
