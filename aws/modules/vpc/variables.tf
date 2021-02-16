variable "env" {
  type    = string
  default = ""
}

variable "cidr" {
  type    = string
  default = ""
}

variable "azs" {
  type    = list(any)
  default = []
}

variable "public_subnets" {
  type    = list(any)
  default = []
}

variable "private_subnets" {
  type    = list(any)
  default = []
}

variable "database_subnets" {
  type    = list(any)
  default = []
}

variable "enable_nat_gateway" {
  type    = bool
  default = false
}

variable "single_nat_gateway" {
  type    = bool
  default = false
}

variable "one_nat_gateway_per_az" {
  type    = bool
  default = false
}
