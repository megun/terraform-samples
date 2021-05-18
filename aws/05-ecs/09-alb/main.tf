module "alb_ecs" {
  source  = "terraform-aws-modules/alb/aws"
  version = "6.0.0"

  name               = "${var.project}-${var.env}-ecs"
  load_balancer_type = "application"
  vpc_id             = data.aws_vpc.main.id
  subnets            = data.aws_subnet_ids.public_subnets.ids
  security_groups    = [data.aws_security_group.alb.id]

  target_groups = [
    {
      name                 = "${var.project}-${var.env}-ecs"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "ip"
      deregistration_delay = 30
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = data.aws_acm_certificate.ecs.arn
      target_group_index = 0
    }
  ]

  tags = local.common_tags
}

resource "aws_route53_record" "ecs" {
  provider = aws.route53

  zone_id = data.aws_route53_zone.ecs.zone_id
  name    = var.domain_hostname
  type    = "A"

  alias {
    name                   = module.alb_ecs.lb_dns_name
    zone_id                = module.alb_ecs.lb_zone_id
    evaluate_target_health = true
  }
}
