module "iam_role_lambda" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "3.6.0"

  create_role = true

  role_name = "${var.project}-${var.env}-lambda-${var.role_name}"

  custom_role_policy_arns = concat(var.attach_policies, [aws_iam_policy.this.arn])

  trusted_role_services = ["lambda.amazonaws.com"]

  role_requires_mfa = false

  tags = {
    Terraform   = "true"
    Project     = var.project
    Environment = var.env
  }
}

resource "aws_iam_policy" "this" {
  name        = "lambda_execution_policy"
  description = "lambda execution policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:log-group:*"
      },
      {
        Action = [
          "logs:CreateLogStream",
          "logs:DescribeLogStreams",
          "logs:PutRetentionPolicy",
          "logs:GetLogEvents",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:log-group:/aws/lambda/${var.function_name}:*"
      }
    ]
  })
}
