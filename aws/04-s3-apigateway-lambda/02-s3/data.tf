data "aws_iam_policy_document" "s3_hosting" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.s3_hosting_bucket_name}/*"]
    effect = "Allow"
    principals {
      type = "*"
      identifiers = ["*"]
    }
  }
}
