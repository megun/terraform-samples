project = "project01"
env     = "prod"

engine_mode    = "provisioned"
engine_version = "5.7.mysql_aurora.2.10.2"
instance_class = "db.t3.small"
instances = {
  1 = {}
  2 = {}
}
enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
preferred_backup_window         = "02:00-03:00"
backup_retention_period         = "7"
preferred_maintenance_window    = "fri:05:00-fri:06:00"
#performance_insights_enabled = true
