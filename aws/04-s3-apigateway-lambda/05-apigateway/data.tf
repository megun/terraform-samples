data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_lambda_function" "lambda" {
  function_name = "${var.project}-${var.env}-lambda"
}
