variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "engine_mode" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type    = string
  default = null
}

variable "scaling_configuration" {
  type    = map(string)
  default = {}
}

variable "instances" {
  type    = map(map(string))
  default = {}
}

variable "enabled_cloudwatch_logs_exports" {
  type    = list(string)
  default = null
}

variable "preferred_backup_window" {
  type = string
}

variable "backup_retention_period" {
  type = string
}

variable "preferred_maintenance_window" {
  type = string
}

variable "performance_insights_enabled" {
  type    = bool
  default = false
}
