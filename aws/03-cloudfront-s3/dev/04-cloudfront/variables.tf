variable "domain_name" {
  type    = string
  default = "demo.megunlabo.net"
}

variable "aliases" {
  type    = list(string)
  default = ["dev-www.demo.megunlabo.net"]
}

variable "contents_bucket_name" {
  type    = string
  default = "megun-cloudfront-s3-dev-contents"
}

variable "log_bucket_name" {
  type    = string
  default = "megun-cloudfront-s3-dev-aws-logs"
}
