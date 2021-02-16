module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "5.10.0"

  name = "${var.env}-${var.name}"

  load_balancer_type = "application"

  vpc_id          = var.vpc_id
  subnets         = var.subnets
  security_groups = var.security_groups

  access_logs = {
    bucket = var.access_logs_bucket
  }

  target_groups = [
    {
      name             = "${var.env}-${var.name}"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = var.certificate_arn
      target_group_index = 0
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}

resource "aws_route53_record" "this" {
  for_each = { for record in var.register_route53 : record.name => record }

  zone_id = each.value.dns_zone_id
  name    = each.value.name
  type    = "A"

  alias {
    name                   = module.alb.this_lb_dns_name
    zone_id                = module.alb.this_lb_zone_id
    evaluate_target_health = true
  }
}
