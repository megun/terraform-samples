output "this_rule_group_arn" {
  description = "RuleGroupArn"
  value       = aws_wafv2_rule_group.this.arn
}
