variable "env" {
  type    = string
  default = ""
}

variable "name" {
  type    = string
  default = ""
}

variable "node_type" {
  type    = string
  default = ""
}

variable "num_cache_nodes" {
  type    = string
  default = ""
}

variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "engine_version" {
  type    = string
  default = ""
}

variable "parameters" {
  type    = list(map(string))
  default = []
}

variable "maintenance_window" {
  type    = string
  default = ""
}

variable "dns_zone_id" {
  type    = string
  default = null
}
