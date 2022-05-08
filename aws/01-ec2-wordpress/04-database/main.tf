### aurora-mysql password
resource "random_password" "aurora-mysql" {
  length           = 16
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_ssm_parameter" "aurora-mysql_master_password" {
  name  = "/${var.project}/${var.env}/aurora-mysql/master_password"
  type  = "SecureString"
  value = random_password.aurora-mysql.result

  lifecycle {
    ignore_changes = [value]
  }
}

### aurora-mysql cluster
module "aurora-mysql" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "7.1.0"

  name           = "${var.project}-${var.env}-aurora-mysql"
  engine         = "aurora-mysql"
  engine_mode    = var.engine_mode
  engine_version = var.engine_version

  instance_class        = var.instance_class
  scaling_configuration = var.scaling_configuration

  instances = var.instances

  vpc_id  = data.aws_vpc.vpc.id
  subnets = data.aws_subnets.db_subnets.ids

  create_random_password = false
  master_username        = "root"
  master_password        = aws_ssm_parameter.aurora-mysql_master_password.value
  database_name          = "wordpress"

  create_security_group  = false
  vpc_security_group_ids = [data.aws_security_group.aurora-mysql.id]

  storage_encrypted   = true
  apply_immediately   = true
  monitoring_interval = 10

  db_parameter_group_name         = aws_db_parameter_group.aurora-mysql.id
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora-mysql.id

  skip_final_snapshot = true

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  performance_insights_enabled = var.performance_insights_enabled

  preferred_backup_window      = var.preferred_backup_window
  backup_retention_period      = var.backup_retention_period
  preferred_maintenance_window = var.preferred_maintenance_window
}

### aurora-mysql parameter group
resource "aws_db_parameter_group" "aurora-mysql" {
  name   = "${var.project}-${var.env}-aurora-mysql"
  family = "aurora-mysql5.7"
}

resource "aws_rds_cluster_parameter_group" "aurora-mysql" {
  name   = "${var.project}-${var.env}-aurora-mysql"
  family = "aurora-mysql5.7"
}

### route53 private zone
resource "aws_route53_record" "writer" {
  zone_id = data.aws_route53_zone.local.zone_id
  name    = "aurora-mysql"
  type    = "CNAME"
  ttl     = 30
  records = [module.aurora-mysql.cluster_endpoint]
}

resource "aws_route53_record" "read" {
  count = var.engine_mode == "serverless" ? 0 : 1

  zone_id = data.aws_route53_zone.local.zone_id
  name    = "read-aurora-mysql"
  type    = "CNAME"
  ttl     = 30
  records = [module.aurora-mysql.cluster_reader_endpoint]
}
