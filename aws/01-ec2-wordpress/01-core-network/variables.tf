variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "enable_nat_gateway" {
  type    = bool
  default = null
}

variable "single_nat_gateway" {
  type    = bool
  default = null
}

variable "one_nat_gateway_per_az" {
  type    = bool
  default = null
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "database_subnets" {
  type = list(string)
}
