data "aws_vpc" "main" {
  tags = {
    Name = var.env
  }
}

resource "aws_route53_zone" "private" {
  name = "${var.env}.local"

  vpc {
    vpc_id = data.aws_vpc.main.id
  }

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}
