variable "env" {
  type = string
}

variable "name" {
  type = string
}

variable "image_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "security_groups" {
  type = list(string)
}

variable "iam_instance_profile" {
  type = string
}

variable "spot_price" {
  type    = string
  default = null
}

variable "enable_monitoring" {
  type    = string
  default = false
}

variable "root_volume_size" {
  type    = string
  default = "30"
}

variable "root_volume_type" {
  type    = string
  default = "gp2"
}

variable "subnet_ids" {
  type = list(string)
}

variable "health_check_type" {
  type = string
}

variable "min_size" {
  type = string
}

variable "max_size" {
  type = string
}

variable "desired_capacity" {
  type = string
}

variable "wait_for_capacity_timeout" {
  type    = string
  default = "0"
}

variable "schedules" {
  type    = list(map(string))
  default = []
}

variable "target_group_arns" {
  type = list(string)
  default = []
}
