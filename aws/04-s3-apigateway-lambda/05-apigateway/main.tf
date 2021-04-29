module "api_gateway" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "1.0.0"

  name          = var.api-gateway_name
  protocol_type = "HTTP"

  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  # Domain
  create_api_domain_name = false

  # Routes and integrations
  integrations = {
    "POST /" = {
      lambda_arn             = data.aws_lambda_function.lambda.arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }

    #"$default" = {
    #  lambda_arn = data.aws_lambda_function.lambda.arn
    #}
  }

  # logs
  default_stage_access_log_destination_arn = aws_cloudwatch_log_group.apigateway.arn
  default_stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"


  tags = {
    Terraform   = "true"
    Environment = var.env
    Project     = var.project
  }
}

resource "aws_lambda_permission" "apigateway" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${module.api_gateway.apigatewayv2_api_execution_arn}/*/*"
}

resource "aws_cloudwatch_log_group" "apigateway" {
  name = "apigateway"

  tags = {
    Terraform   = "true"
    Environment = var.env
    Project     = var.project
  }
}
