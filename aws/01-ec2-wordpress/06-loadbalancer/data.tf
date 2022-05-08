data "aws_vpc" "vpc" {
  tags = {
    Name = "${var.project}-${var.env}"
  }
}

data "aws_route53_zone" "public" {
  name = "${var.domain}"
}

data "aws_route53_zone" "local" {
  name         = "${var.env}-${var.project}.local"
  private_zone = true
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

data "aws_security_group" "alb" {
  tags = {
    Name = "${var.project}-${var.env}-alb"
  }
}

data "aws_acm_certificate" "acm" {
  domain = "${var.env}-${var.project}.megunlabo.net"
}
