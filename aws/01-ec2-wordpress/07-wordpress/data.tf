data "aws_vpc" "vpc" {
  tags = {
    Name = "${var.project}-${var.env}"
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  tags = {
    Tier = "private"
  }
}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  tags = {
    Tier = "public"
  }
}

data "aws_security_group" "wordpress" {
  tags = {
    Name = "${var.project}-${var.env}-wordpress"
  }
}

data "aws_lb_target_group" "alb" {
  name = "${var.project}-${var.env}-wordpress"
}

data "template_file" "user_data" {
  template = file("user_data.sh")
}


data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "ssm_sendcommand" {
  statement {
    sid = "1"

    actions = [
      "ssm:SendCommand",
    ]
    resources = [
      "arn:aws:ssm:*:*:document/*",
      "arn:aws:ec2:*:*:instance/*",
    ]
  }
}

data "aws_iam_policy_document" "ssm_parameterstore" {
  statement {
    sid = "1"

    actions = [
      "ssm:GetParameters",
    ]
    resources = [
      "arn:aws:ssm:ap-northeast-1:${data.aws_caller_identity.current.account_id}:parameter/${var.project}/${var.env}/*"
    ]
  }
}
