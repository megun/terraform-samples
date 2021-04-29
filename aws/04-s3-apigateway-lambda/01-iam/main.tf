module "iam_role_lambda" {
  source = "../../modules/iam/role/lambda"

  project       = var.project
  env           = var.env
  role_name     = "sample"
  function_name = var.lambda_function_name

  attach_policies = [aws_iam_policy.dynamodb.arn]
}

resource "aws_iam_policy" "dynamodb" {
  name        = "sample_lambda_dynamodb"
  description = "sample lambda dynamodb"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:UpdateItem"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:dynamodb:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:table/${var.dynamodb_tablename}"
      }
    ]
  })
}
