module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "6.10.0"

  name = "${var.project}-${var.env}-alb"

  load_balancer_type = "application"

  vpc_id          = data.aws_vpc.vpc.id
  subnets         = data.aws_subnets.public_subnets.ids
  security_groups = [data.aws_security_group.alb.id]

  access_logs = {
    bucket = "megun-${var.project}-${var.env}-aws-logs"
  }

  target_groups = [
    {
      name                 = "${var.project}-${var.env}-wordpress"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 60
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = data.aws_acm_certificate.acm.arn
      target_group_index = 0
    }
  ]
}

resource "aws_route53_record" "alb" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "${var.hostname}.${var.domain}"
  type    = "A"

  alias {
    name                   = module.alb.lb_dns_name
    zone_id                = module.alb.lb_zone_id
    evaluate_target_health = true
  }
}
