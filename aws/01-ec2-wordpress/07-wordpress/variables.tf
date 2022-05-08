variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "min_size" {
  type = string
}

variable "max_size" {
  type = string
}

variable "health_check_type" {
  type = string
}

variable "image_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "root_volume_size" {
  type = string
}

variable "custom_role_policy_arns" {
  type    = list(string)
  default = []
}
