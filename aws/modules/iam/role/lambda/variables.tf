variable "project" {
  type    = string
  default = ""
}

variable "env" {
  type    = string
  default = ""
}

variable "role_name" {
  type = string
}

variable "function_name" {
  type = string
}

variable "attach_policies" {
  type    = list(any)
  default = []
}
