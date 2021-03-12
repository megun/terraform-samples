variable "project" {
  type    = string
  default = ""
}

variable "env" {
  type    = string
  default = ""
}

variable "name" {
  type    = string
  default = ""
}

variable "instance_count" {
  type    = string
  default = 1
}

variable "ami" {
  type    = string
  default = ""
}

variable "instance_type" {
  type    = string
  default = ""
}

variable "security_group_ids" {
  type    = list(any)
  default = []
}

variable "subnet_ids" {
  type    = list(any)
  default = []
}

variable "iam_instance_profile" {
  type    = string
  default = ""
}

variable "root_volume_size" {
  type    = string
  default = ""
}

variable "attach_eip" {
  type    = bool
  default = false
}

variable "user_data_base64" {
  type    = string
  default = ""
}

variable "dns_zone_id" {
  type    = string
  default = null
}

variable "dns_name" {
  type    = string
  default = ""
}
