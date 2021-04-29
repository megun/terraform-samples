resource "aws_lambda_function" "test_lambda" {
  filename      = data.archive_file.source.output_path
  function_name = "${var.project}-${var.env}-lambda"
  role          = data.aws_iam_role.lambda.arn
  handler       = "main.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = data.archive_file.source.output_base64sha256

  runtime = "python3.8"
}
