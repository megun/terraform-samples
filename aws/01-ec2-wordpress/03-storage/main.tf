module "aws_logs" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.2.0"

  bucket = "megun-${var.project}-${var.env}-aws-logs"
  acl    = "log-delivery-write"

  force_destroy = true

  attach_elb_log_delivery_policy = true
}
