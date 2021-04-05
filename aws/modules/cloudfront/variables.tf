variable "project" {
  type    = string
  default = ""
}

variable "env" {
  type    = string
  default = ""
}

variable "origin" {
  type    = any
  default = []
}

variable "enabled" {
  type    = bool
  default = true
}

variable "is_ipv6_enabled" {
  type    = bool
  default = false
}

variable "comment" {
  type = string
}

variable "acm_certificate_arn" {
  type    = string
  default = null
}

variable "cloudfront_default_certificate" {
  type    = bool
  default = null
}

variable "minimum_protocol_version" {
  type    = string
  default = "TLSv1.2_2019"
}

variable "ssl_support_method" {
  type    = string
  default = "sni-only"
}

variable "aliases" {
  type    = list(string)
  default = null
}

variable "default_cache_behavior" {
  type    = any
  default = {}
}

variable "ordered_cache_behavior" {
  type    = any
  default = []
}

variable "logging_config_bucket" {
  type    = string
  default = null
}

variable "logging_config_include_cookies" {
  type    = bool
  default = false
}

variable "logging_config_prefix" {
  type    = string
  default = null
}

variable "register_route53" {
  type    = list(map(string))
  default = []
}

variable "web_acl_id" {
  type    = string
  default = null
}
