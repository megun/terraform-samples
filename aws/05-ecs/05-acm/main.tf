module "acm" {
  providers = {
    aws.route53 = aws.route53
  }

  source = "../../modules/acm"

  domain_name = "${var.domain_hostname}.${var.domain_name}"
  subject_alternative_names = [
    "*.${var.domain_name}",
  ]

  zone_id = data.aws_route53_zone.main.zone_id
}
