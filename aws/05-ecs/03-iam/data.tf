data "aws_iam_policy_document" "parameterstore" {
  statement {
    actions = [
      "ssm:DescribeParameters*",
    ]
    effect = "Allow"
    resources = [
      "*"
    ]
  }
  statement {
    actions = [
      "ssm:GetParameters*",
    ]
    effect = "Allow"
    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.id}:parameter/${var.project}-${var.env}/*"
    ]
  }
}
