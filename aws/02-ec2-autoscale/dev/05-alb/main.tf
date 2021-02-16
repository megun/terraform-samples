data "aws_vpc" "main" {
  tags = {
    Name = var.env
  }
}

data "aws_subnet_ids" "public_subnets" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Tier = "public"
  }
}

data "aws_security_group" "alb_web" {
  tags = {
    Name = "${var.env}-alb-web"
  }
}

data "aws_acm_certificate" "demo" {
  domain   = var.crt_domain
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "demo" {
  name         = regex("\\.(.+$)", var.crt_domain)[0]
  private_zone = false
}

module "alb_web" {
  source = "../../../modules/alb"

  env  = var.env
  name = "web"

  vpc_id          = data.aws_vpc.main.id
  subnets         = data.aws_subnet_ids.public_subnets.ids
  security_groups = [data.aws_security_group.alb_web.id]

  access_logs_bucket = "megun-${var.env}-aws-logs"

  certificate_arn = data.aws_acm_certificate.demo.arn

  register_route53 = [
    {
      dns_zone_id = data.aws_route53_zone.demo.zone_id
      name        = "${var.env}-web"
    },
  ]
}
