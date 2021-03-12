data "aws_vpc" "main" {
  tags = {
    Name = "${var.project}-${var.env}"
  }
}

resource "aws_route53_zone" "private" {
  name = "${var.project}-${var.env}.local"

  vpc {
    vpc_id = data.aws_vpc.main.id
  }

  tags = {
    Terraform   = "true"
    Environment = var.env
    Project     = var.project
  }
}
