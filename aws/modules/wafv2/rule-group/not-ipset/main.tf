
resource "aws_wafv2_ip_set" "this" {
  name               = "${var.project}-${var.env}-${var.ip_set_name}"
  description        = var.ip_set_description
  scope              = var.scope
  ip_address_version = var.ip_address_version
  addresses          = var.addresses
}

resource "aws_wafv2_rule_group" "this" {
  name     = "${var.project}-${var.env}-${var.rule_group_name}"
  scope    = var.scope
  capacity = 1

  rule {
    name     = "rule-01"
    priority = 0

    action {
      block {}
    }

    statement {
      not_statement {
        statement {
          ip_set_reference_statement {
            arn = aws_wafv2_ip_set.this.arn
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = var.rule_cloudwatch_metrics_enabled
      metric_name                = var.rule_metric_name_rule == null ? "${var.project}-${var.env}-${var.rule_group_name}-rule-default" : var.rule_metric_name_rule
      sampled_requests_enabled   = var.rule_sampled_requests_enabled_rule
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
    metric_name                = var.metric_name_rule == null ? "${var.project}-${var.env}-${var.rule_group_name}-default" : var.metric_name_rule
    sampled_requests_enabled   = var.sampled_requests_enabled_rule
  }
}
