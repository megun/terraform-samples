variable "env" {
  type    = string
  default = ""
}

variable "role_name" {
  type    = string
  default = ""
}

variable "attach_policies" {
  type    = list(any)
  default = []
}
