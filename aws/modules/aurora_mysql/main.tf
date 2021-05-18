resource "random_string" "this" {
  length           = 15
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  override_special = "!#$%&*()-_=+[]{}<>:?"
  #  override_special = "/@\" "
}

resource "aws_ssm_parameter" "this" {
  name        = "/${var.project}-${var.env}/${var.name}/master_pass"
  description = "The parameter description"
  type        = "SecureString"
  value       = random_string.this.result

  tags = var.tags
}

resource "aws_db_parameter_group" "this" {
  name        = "${var.project}-${var.env}-aurora-db-57-parameter-group"
  family      = "aurora-mysql5.7"
  description = "${var.project}-${var.env}-aurora-db-57-parameter-group"

  dynamic "parameter" {
    for_each = var.db_parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }

  tags = var.tags
}

resource "aws_rds_cluster_parameter_group" "this" {
  name        = "${var.project}-${var.env}-aurora-57-cluster-parameter-group"
  family      = "aurora-mysql5.7"
  description = "${var.project}-${var.env}-aurora-57-cluster-parameter-group"

  dynamic "parameter" {
    for_each = var.cluster_parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }

  tags = var.tags
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.project}-${var.env}-${var.name}"
  subnet_ids = var.subnet_ids

  tags = var.tags
}

resource "aws_rds_cluster" "this" {
  cluster_identifier              = "${var.project}-${var.env}-${var.name}"
  engine                          = "aurora-mysql"
  engine_mode                     = var.engine_mode
  engine_version                  = var.engine_version
  db_subnet_group_name            = aws_db_subnet_group.this.name
  vpc_security_group_ids          = var.security_group_ids
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this.id
  database_name                   = var.database_name
  master_username                 = var.username
  master_password                 = aws_ssm_parameter.this.value
  backup_retention_period         = var.backup_retention_period
  preferred_backup_window         = var.preferred_backup_window
  preferred_maintenance_window    = var.preferred_maintenance_window
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  skip_final_snapshot             = "true"

  # for serverless options
  enable_http_endpoint = var.enable_http_endpoint

  dynamic "scaling_configuration" {
    for_each = length(var.scaling_configuration) == 0 ? [] : [var.scaling_configuration]
    iterator = config

    content {
      auto_pause               = lookup(config.value, "auto_pause", null)
      max_capacity             = lookup(config.value, "max_capacity", null)
      min_capacity             = lookup(config.value, "min_capacity", null)
      seconds_until_auto_pause = lookup(config.value, "seconds_until_auto_pause", null)
      timeout_action           = lookup(config.value, "timeout_action", null)
    }
  }

  lifecycle {
    ignore_changes = [master_password]
  }

  tags = var.tags
}

resource "aws_rds_cluster_instance" "this" {
  count                        = var.replica_count
  identifier_prefix            = "${var.project}-${var.env}-${var.name}"
  cluster_identifier           = aws_rds_cluster.this.id
  instance_class               = var.instance_type
  engine                       = aws_rds_cluster.this.engine
  engine_version               = aws_rds_cluster.this.engine_version
  db_parameter_group_name      = aws_db_parameter_group.this.id
  apply_immediately            = true
  preferred_maintenance_window = var.preferred_maintenance_window
  auto_minor_version_upgrade   = false

  tags = var.tags
}

resource "aws_route53_record" "write" {
  count = var.dns_zone_id != null ? 1 : 0

  zone_id = var.dns_zone_id
  name    = var.name
  type    = "CNAME"
  ttl     = 30
  records = [aws_rds_cluster.this.endpoint]
}

resource "aws_route53_record" "read" {
  count = (var.engine_mode == "serverless" || var.dns_zone_id == null) ? 0 : 1

  zone_id = var.dns_zone_id
  name    = "read-${var.name}"
  type    = "CNAME"
  ttl     = 30
  records = [aws_rds_cluster.this.reader_endpoint]
}
