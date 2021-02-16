variable "domain_name" {
  type = string
}

variable "subject_alternative_names" {
  type    = list(string)
  default = null
}

variable "zone_id" {
  type = string
}
