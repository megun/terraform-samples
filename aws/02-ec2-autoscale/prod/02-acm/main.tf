data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}

module "acm_demo" {
  source = "../../../modules/acm"

  domain_name = "web.${var.domain_name}"
  zone_id     = data.aws_route53_zone.main.zone_id
}
