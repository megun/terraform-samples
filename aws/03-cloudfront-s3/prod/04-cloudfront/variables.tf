variable "domain_name" {
  type    = string
  default = "demo.megunlabo.net"
}

variable "aliases" {
  type    = list(string)
  default = ["www.demo.megunlabo.net"]
}

variable "contents_bucket_name" {
  type    = string
  default = "megun-cloudfront-s3-prod-contents"
}

variable "log_bucket_name" {
  type    = string
  default = "megun-cloudfront-s3-prod-aws-logs"
}
