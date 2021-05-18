data "aws_route53_zone" "local" {
  name         = local.domain_name_private
  private_zone = true
}

data "aws_security_group" "aurora_mysql" {
  tags = {
    Name = "${var.project}-${var.env}-aurora-mysql"
  }
}
