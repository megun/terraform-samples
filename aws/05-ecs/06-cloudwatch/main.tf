resource "aws_cloudwatch_log_group" "ecs" {
  for_each = toset([
    var.cw_loggroup_frontend,
    var.cw_loggroup_backend,
  ])

  name              = each.key
  retention_in_days = 7
  tags              = local.common_tags
}
