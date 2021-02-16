data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}

module "acm_demo" {
  #source  = "terraform-aws-modules/acm/aws"
  #version = "2.12.0"
  source = "../../../modules/acm"

  domain_name = "${var.env}-web.${var.domain_name}"
  zone_id     = data.aws_route53_zone.main.zone_id

  #subject_alternative_names = [
  #  #"*.${var.var.domain_name}",
  #  "${var.env}-web.${var.domain_name}",
  #]
}
