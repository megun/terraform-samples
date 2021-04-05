locals {
  myip = [format("%s/32", chomp(data.http.ifconfig.body))]
}

module "wafv2-rule-group-not-ipset" {
  source = "../../../modules/wafv2/rule-group/not-ipset"

  project = var.project
  env     = var.env

  ip_set_name        = "developers"
  ip_set_description = "developers"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = concat(var.developers, local.myip)
  rule_group_name    = "not-developers-ip"
}

module "wafv2" {
  source = "../../../modules/wafv2"

  project = var.project
  env     = var.env
  name    = "sample"

  scope          = "CLOUDFRONT"
  default_action = "allow" # "allow" or "block"

  rules = [
    {
      name            = "AWSManagedRulesCommonRuleSet"
      priority        = 1
      override_action = "count"

      managed_rule = {
        name           = "AWSManagedRulesCommonRuleSet"
        vendor_name    = "AWS"
        excluded_rules = ["SizeRestrictions_QUERYSTRING", "NoUserAgent_HEADER"]
      }
    },
    {
      name            = "AWSManagedRulesSQLiRuleSet"
      priority        = 2
      override_action = "none"

      managed_rule = {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }

      #cloudwatch_metrics_enabled = true # default false
      #sampled_requests_enabled   = true # default false
    },
    {
      name            = "IPSetRule"
      priority        = 0
      override_action = "none"

      rule_group = {
        arn = module.wafv2-rule-group-not-ipset.this_rule_group_arn
      }
    },
  ]

  #cloudwatch_metrics_enabled = true # default false
  #metric_name                = "hogehoge" # default ${var.project}-${var.env}-${rule.value["name"]}-default"
  #sampled_requests_enabled = true # default false
}
