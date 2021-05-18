variable "name" {
  type = string
}

variable "scan_on_push" {
  type    = bool
  default = true
}

variable "policy" {
  type    = any
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
