resource "aws_cloudfront_origin_access_identity" "s3_contents" {
  comment = "${var.env}_s3_contents"
}

module "s3_contents" {
  source = "../../../modules/s3"

  project = var.project
  env     = var.env
  name    = var.contents_bucket_name

  acl                     = "private"
  block_all_public_access = true
  policy                  = data.aws_iam_policy_document.cloudfront_origin_access_identity.json

  sse_enc_defaults = [
    {
      sse_algorithm = "AES256"
    },
  ]

  versioning    = true
  force_destroy = true
}

module "cloudfront" {
  source = "../../../modules/cloudfront"
  providers = {
    aws.route53 = aws.route53
  }

  is_ipv6_enabled = true
  comment         = "s3 distribution"
  aliases         = var.aliases

  acm_certificate_arn = data.aws_acm_certificate.demo.arn

  origin = [
    {
      domain_name = module.s3_contents.this_s3_bucket_bucket_regional_domain_name
      origin_id   = var.contents_bucket_name
      s3_origin_config = {
        origin_access_identity = aws_cloudfront_origin_access_identity.s3_contents.cloudfront_access_identity_path
      }
    }
  ]

  default_cache_behavior = {
    target_origin_id         = var.contents_bucket_name
    cache_policy_id          = data.aws_cloudfront_cache_policy.managed-cachingoptimized.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.managed-cors-s3origin.id
  }

  ordered_cache_behavior = [
    {
      path_pattern             = "/nocache/*"
      target_origin_id         = var.contents_bucket_name
      cache_policy_id          = data.aws_cloudfront_cache_policy.managed-cachingdisabled.id
      origin_request_policy_id = data.aws_cloudfront_origin_request_policy.managed-cors-s3origin.id
    }
  ]

  logging_config_bucket = "${var.log_bucket_name}.s3.amazonaws.com"

  register_route53 = [
    {
      dns_zone_id = data.aws_route53_zone.demo.zone_id
      name        = var.aliases[0]
    },
  ]

  web_acl_id = data.aws_wafv2_web_acl.sample.arn
}
