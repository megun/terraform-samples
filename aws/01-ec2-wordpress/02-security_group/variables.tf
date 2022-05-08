variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "allow_ips_wordpress" {
  type = list(string)
}

locals {
  myip = [format("%s/32", chomp(data.http.ifconfig.body))]
}
