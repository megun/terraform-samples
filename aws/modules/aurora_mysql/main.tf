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
  name        = "/${var.env}/aurora_mysql/master_pass"
  description = "The parameter description"
  type        = "SecureString"
  value       = random_string.this.result

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}

resource "aws_db_parameter_group" "this" {
  name        = "${var.env}-aurora-db-57-parameter-group"
  family      = "aurora-mysql5.7"
  description = "${var.env}-aurora-db-57-parameter-group"

  dynamic "parameter" {
    for_each = var.db_parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}

resource "aws_rds_cluster_parameter_group" "this" {
  name        = "${var.env}-aurora-57-cluster-parameter-group"
  family      = "aurora-mysql5.7"
  description = "${var.env}-aurora-57-cluster-parameter-group"

  dynamic "parameter" {
    for_each = var.cluster_parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.env}-${var.name}"
  subnet_ids = var.subnet_ids

  tags = {
    Name        = "${var.env}-${var.name}"
    Terraform   = "true"
    Environment = var.env
  }
}

resource "aws_rds_cluster" "this" {
  cluster_identifier              = "${var.env}-${var.name}"
  engine                          = "aurora-mysql"
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

  tags = {
    Name        = "${var.env}-${var.name}"
    Terraform   = "true"
    Environment = var.env
  }
}

resource "aws_rds_cluster_instance" "this" {
  count                        = var.replica_count
  identifier_prefix            = "${var.env}-${var.name}"
  cluster_identifier           = aws_rds_cluster.this.id
  instance_class               = var.instance_type
  engine                       = aws_rds_cluster.this.engine
  engine_version               = aws_rds_cluster.this.engine_version
  db_parameter_group_name      = aws_db_parameter_group.this.id
  apply_immediately            = true
  preferred_maintenance_window = var.preferred_maintenance_window
  auto_minor_version_upgrade   = false

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
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
  count = var.dns_zone_id != null ? 1 : 0

  zone_id = var.dns_zone_id
  name    = "read-${var.name}"
  type    = "CNAME"
  ttl     = 30
  records = [aws_rds_cluster.this.reader_endpoint]
}

/*
module "aurora_mysql" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "3.3.0"

  name = "${var.env}-${var.name}"

  engine = "aurora-mysql"

  engine_version = var.engine_version

  vpc_id  = var.vpc_id
  subnets = var.subnets

  replica_count = var.replica_count

  instance_type     = var.instance_type
  storage_encrypted = true
  apply_immediately = true

  db_parameter_group_name         = aws_db_parameter_group.rds-aurora.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.rds-aurora.id

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  backup_retention_period    = var.backup_retention_period

  database_name = var.database_name
  username      = var.username
  #password      = aws_ssm_parameter.aurora_mysql_master_pass.value
  password = "hoge"

  performance_insights_enabled = true

  tags = {
    Name        = "${var.env}-${var.name}"
    Terraform   = "true"
    Environment = var.env
  }
}
*/
