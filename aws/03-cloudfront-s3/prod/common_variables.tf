variable "project" {
  type    = string
  default = "cloudfront-s3"
}

variable "env" {
  type    = string
  default = "prod"
}

variable "assume_role" {
  type = string
  # .envrcにTF_VAR_assume_roleを設定している
  #default = "arn:aws:iam::123456789:role/role-name"
}
