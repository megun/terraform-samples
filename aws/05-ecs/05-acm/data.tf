data "aws_route53_zone" "main" {
  provider     = aws.route53
  name         = var.domain_name
  private_zone = false
}
