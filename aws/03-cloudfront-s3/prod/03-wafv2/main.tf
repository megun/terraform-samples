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

      cloudwatch_metrics_enabled = true # default false
      sampled_requests_enabled   = true # default false
    },
  ]

  cloudwatch_metrics_enabled = true # default false
  #metric_name                = "hogehoge" # default ${var.project}-${var.env}-${rule.value["name"]}-default"
  sampled_requests_enabled = true # default false
}
