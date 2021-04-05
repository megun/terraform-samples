resource "aws_cloudfront_distribution" "this" {
  dynamic "origin" {
    for_each = var.origin
    content {
      domain_name = lookup(origin.value, "domain_name", null)
      origin_id   = lookup(origin.value, "origin_id", null)

      dynamic "s3_origin_config" {
        for_each = length(keys(lookup(origin.value, "s3_origin_config", {}))) == 0 ? [] : [lookup(origin.value, "s3_origin_config", {})]
        content {
          origin_access_identity = lookup(s3_origin_config.value, "origin_access_identity", null)
        }
      }
    }
  }

  enabled         = var.enabled
  is_ipv6_enabled = var.is_ipv6_enabled
  comment         = var.comment

  aliases = var.aliases

  viewer_certificate {
    acm_certificate_arn            = var.acm_certificate_arn
    cloudfront_default_certificate = var.cloudfront_default_certificate

    minimum_protocol_version = var.minimum_protocol_version
    ssl_support_method       = var.ssl_support_method
  }

  dynamic "default_cache_behavior" {
    for_each = [var.default_cache_behavior]
    iterator = i

    content {
      allowed_methods          = lookup(i.value, "allowed_methods", ["GET", "HEAD", "OPTIONS"])
      cached_methods           = lookup(i.value, "cached_methods", ["GET", "HEAD", "OPTIONS"])
      target_origin_id         = lookup(i.value, "target_origin_id", null)
      cache_policy_id          = lookup(i.value, "cache_policy_id", null)
      origin_request_policy_id = lookup(i.value, "origin_request_policy_id", null)
      viewer_protocol_policy   = lookup(i.value, "viewer_protocol_policy", "redirect-to-https")
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behavior
    iterator = i

    content {
      path_pattern             = lookup(i.value, "path_pattern", null)
      allowed_methods          = lookup(i.value, "allowed_methods", ["GET", "HEAD", "OPTIONS"])
      cached_methods           = lookup(i.value, "cached_methods", ["GET", "HEAD"])
      target_origin_id         = lookup(i.value, "target_origin_id", null)
      cache_policy_id          = lookup(i.value, "cache_policy_id", null)
      origin_request_policy_id = lookup(i.value, "origin_request_policy_id", null)
      viewer_protocol_policy   = lookup(i.value, "viewer_protocol_policy", "redirect-to-https")
    }
  }

  web_acl_id = var.web_acl_id

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  logging_config {
    include_cookies = var.logging_config_include_cookies
    bucket          = var.logging_config_bucket
    prefix          = var.logging_config_prefix
  }

  tags = {
    Terraform   = "true"
    Environment = var.env
    Project     = var.project
  }
}

resource "aws_route53_record" "this" {
  provider = aws.route53

  for_each = { for record in var.register_route53 : record.name => record }

  zone_id = each.value.dns_zone_id
  name    = each.value.name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = true
  }
}
