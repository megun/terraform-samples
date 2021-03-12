module "s3_aws_logs" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "1.17.0"

  bucket = "megun-${var.project}-${var.env}-aws-logs"
  acl    = "log-delivery-write"

  attach_elb_log_delivery_policy = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Terraform   = "true"
    Environment = var.env
    Project     = var.project
  }
}
