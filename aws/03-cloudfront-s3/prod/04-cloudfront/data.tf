data "aws_route53_zone" "demo" {
  provider     = aws.route53
  name         = var.domain_name
  private_zone = false
}

data "aws_acm_certificate" "demo" {
  domain   = var.domain_name
  statuses = ["ISSUED"]
  provider = aws.us-east-1
}

data "aws_cloudfront_cache_policy" "managed-cachingoptimized" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_cache_policy" "managed-cachingdisabled" {
  name = "Managed-CachingDisabled"
}

data "aws_cloudfront_origin_request_policy" "managed-cors-s3origin" {
  name = "Managed-CORS-S3Origin"
}

data "aws_cloudfront_origin_request_policy" "managed-allviewer" {
  name = "Managed-AllViewer"
}

data "aws_iam_policy_document" "cloudfront_origin_access_identity" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.contents_bucket_name}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.s3_contents.iam_arn]
    }
  }
}

data "aws_wafv2_web_acl" "sample" {
  name     = "${var.project}-${var.env}-sample"
  scope    = "CLOUDFRONT"
  provider = aws.us-east-1
}
