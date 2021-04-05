resource "aws_wafv2_web_acl" "this" {
  name        = "${var.project}-${var.env}-${var.name}"
  description = var.description
  scope       = var.scope

  default_action {
    dynamic "allow" {
      for_each = var.default_action == "allow" ? [1] : []
      content {}
    }

    dynamic "block" {
      for_each = var.default_action == "block" ? [1] : []
      content {}
    }
  }

  dynamic "rule" {
    for_each = var.rules
    content {
      name     = lookup(rule.value, "name", null)
      priority = lookup(rule.value, "priority", null)

      dynamic "override_action" {
        for_each = lookup(rule.value, "override_action", null) != null ? [1] : []

        content {
          dynamic "none" {
            #for_each = lookup(rule.value, "override_action", null) == "none" || lookup(rule.value, "override_action", null) == null ? [1] : []
            for_each = lookup(rule.value, "override_action", null) == "none" ? [1] : []
            content {}
          }
          dynamic "count" {
            for_each = lookup(rule.value, "override_action", null) == "count" ? [1] : []
            content {}
          }
        }
      }

      dynamic "action" {
        for_each = lookup(rule.value, "action", null) != null ? [1] : []

        content {
          dynamic "allow" {
            for_each = lookup(rule.value, "action", null) == "allow" ? [1] : []
            content {}
          }
          dynamic "block" {
            for_each = lookup(rule.value, "action", null) == "block" ? [1] : []
            content {}
          }
          dynamic "count" {
            for_each = lookup(rule.value, "action", null) == "count" ? [1] : []
            content {}
          }
        }
      }

      statement {
        dynamic "managed_rule_group_statement" {
          for_each = lookup(rule.value, "managed_rule", null) == null ? [] : [lookup(rule.value, "managed_rule", null)]
          iterator = managed_rule

          content {
            name        = lookup(managed_rule.value, "name", null)
            vendor_name = lookup(managed_rule.value, "vendor_name", null)

            dynamic "excluded_rule" {
              for_each = lookup(managed_rule.value, "excluded_rules", null) == null ? [] : lookup(managed_rule.value, "excluded_rules", null)

              content {
                name = excluded_rule.value
              }
            }
          }
        }

        dynamic "ip_set_reference_statement" {
          for_each = lookup(rule.value, "ipset_rule", null) == null ? [] : [lookup(rule.value, "ipset_rule", null)]
          iterator = ipset_rule

          content {
            arn = lookup(ipset_rule.value, "arn", null)
            #ip_set_forwarded_ip_config {
            #  fallback_behavior = ""
            #  header_name = ""
            #  position = ""
            #}
          }
        }

        dynamic "rule_group_reference_statement" {
          for_each = lookup(rule.value, "rule_group", null) == null ? [] : [lookup(rule.value, "rule_group", null)]
          iterator = rule_group

          content {
            arn = lookup(rule_group.value, "arn", null)
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = lookup(rule.value, "cloudwatch_metrics_enabled", false)
        metric_name                = lookup(rule.value, "metric_name", "${var.project}-${var.env}-${rule.value["name"]}-default")
        sampled_requests_enabled   = lookup(rule.value, "sampled_requests_enabled", false)
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = var.cloudwatch_metrics_enabled
    metric_name                = var.metric_name == "" ? "${var.project}-${var.env}-${var.name}-acl-default" : var.metric_name
    sampled_requests_enabled   = var.sampled_requests_enabled
  }

  tags = {
    Terraform   = "true"
    Environment = var.env
    Project     = var.project
  }
}
