variable "project" {
  type    = string
  default = ""
}

variable "env" {
  type    = string
  default = ""
}

variable "rule_group_name" {
  type = string
}

variable "cloudwatch_metrics_enabled" {
  type    = bool
  default = false
}

variable "metric_name_rule" {
  type    = string
  default = null
}

variable "sampled_requests_enabled_rule" {
  type    = bool
  default = false
}

variable "rule_cloudwatch_metrics_enabled" {
  type    = bool
  default = false
}

variable "rule_metric_name_rule" {
  type    = string
  default = null
}

variable "rule_sampled_requests_enabled_rule" {
  type    = bool
  default = false
}

variable "ip_set_name" {
  type = string
}

variable "ip_set_description" {
  type    = string
  default = ""
}

variable "scope" {
  type = string
}

variable "ip_address_version" {
  type    = string
  default = "IPV4"
}

variable "addresses" {
  type = list(string)
}
