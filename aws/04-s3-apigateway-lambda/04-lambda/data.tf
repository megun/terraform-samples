data "aws_iam_role" "lambda" {
  name = "${var.project}-${var.env}-lambda-sample"
}

data "archive_file" "source" {
  type        = "zip"
  source_dir = "../app/python/"
  output_path = "./source.zip"
}
