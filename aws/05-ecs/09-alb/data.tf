data "aws_security_group" "alb" {
  tags = {
    Name = "${var.project}-${var.env}-alb"
  }
}

data "aws_acm_certificate" "ecs" {
  domain   = "${var.domain_hostname}.${var.domain_name}"
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "ecs" {
  name         = var.domain_name
  private_zone = false
  provider     = aws.route53
}
