project = "project01"
env     = "dev"

engine_mode = "serverless"
#engine_version = "5.7.mysql_aurora.2.10.2"
engine_version = "mysql_aurora.3.02.0"
scaling_configuration = {
  auto_pause               = true
  min_capacity             = 1
  max_capacity             = 2
  seconds_until_auto_pause = 300
  timeout_action           = "ForceApplyCapacityChange"
}
preferred_backup_window      = "02:00-03:00"
backup_retention_period      = "1"
preferred_maintenance_window = "wed:05:00-wed:06:00"
