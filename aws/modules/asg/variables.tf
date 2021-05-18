variable "lt_name" {
  type    = string
  default = ""
}

variable "block_device_mappings" {
  type    = list(any)
  default = []
}

variable "iam_instance_profile" {
  type    = string
  default = null
}

variable "image_id" {
  type    = string
  default = null
}

variable "vpc_security_group_ids" {
  type    = list(string)
  default = null
}

variable "user_data" {
  type    = string
  default = null
}

variable "update_default_version" {
  type    = bool
  default = true
}

variable "mixed_instances_policy" {
  type    = any
  default = null
}

variable "health_check_type" {
  type = string
}

variable "vpc_zone_identifier" {
  type = list(string)
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "desired_capacity" {
  type = number

}

variable "asg_name" {
  type = string
}

variable "default_tags" {
  type = map(string)
  default = {
    Terraform = "true"
  }
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "protect_from_scale_in" {
  type    = bool
  default = null
}
