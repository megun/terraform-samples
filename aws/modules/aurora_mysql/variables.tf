variable "env" {
  type    = string
  default = ""
}

variable "name" {
  type    = string
  default = ""
}

variable "engine_version" {
  type    = string
  default = ""
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "subnet_ids" {
  type    = list(any)
  default = []
}

variable "security_group_ids" {
  type    = list(any)
  default = []
}

variable "replica_count" {
  type    = string
  default = 1
}

variable "instance_type" {
  type    = string
  default = ""
}

variable "enabled_cloudwatch_logs_exports" {
  type    = list(any)
  default = []
}

variable "auto_minor_version_upgrade" {
  type    = bool
  default = false
}

variable "backup_retention_period" {
  type    = string
  default = 7
}

variable "preferred_backup_window" {
  type    = string
  default = ""
}

variable "preferred_maintenance_window" {
  type    = string
  default = ""
}

variable "database_name" {
  type    = string
  default = ""
}

variable "username" {
  type    = string
  default = ""
}

variable "cluster_parameters" {
  type    = list(map(string))
  default = []
}

variable "db_parameters" {
  type    = list(map(string))
  default = []
}

variable "dns_zone_id" {
  type    = string
  default = null
}
