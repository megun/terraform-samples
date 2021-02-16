variable "env" {
  type    = string
  default = ""
}

variable "name" {
  type    = string
  default = ""
}

variable "vpc_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}

variable "certificate_arn" {
  type = string
}

variable "access_logs_bucket" {
  type = string
}

variable "register_route53" {
  type    = list(map(string))
  default = []
}
