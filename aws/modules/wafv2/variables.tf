variable "project" {
  type    = string
  default = ""
}

variable "env" {
  type    = string
  default = ""
}

variable "name" {
  type = string
}

variable "description" {
  type    = string
  default = null
}

variable "scope" {
  type = string
}

variable "default_action" {
  type = string
}

variable "cloudwatch_metrics_enabled" {
  type    = bool
  default = false
}

variable "metric_name" {
  type    = string
  default = ""
}

variable "sampled_requests_enabled" {
  type    = bool
  default = false
}

variable "rules" {
  type    = any
  default = []
}
