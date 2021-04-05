module "s3_aws_logs" {
  source = "../../../modules/s3"

  project = var.project
  env     = var.env
  name    = "megun-${var.project}-${var.env}-aws-logs"

  block_all_public_access = true

  grants = [
    {
      id          = data.aws_canonical_user_id.current.id
      permissions = ["FULL_CONTROL"]
      type        = "CanonicalUser"
    },
    {
      # Grant CloudFront logs access to your Amazon S3 Bucket
      # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/AccessLogs.html#AccessLogsBucketAndFileOwnership
      id          = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
      permissions = ["FULL_CONTROL"]
      type        = "CanonicalUser"
    },
  ]

  sse_enc_defaults = [
    {
      sse_algorithm = "AES256"
    },
  ]

  force_destroy = true
}
