resource "aws_s3_bucket" "this" {
  bucket = var.name
  acl    = var.acl

  policy = var.policy

  dynamic "grant" {
    for_each = var.grants

    content {
      id          = lookup(grant.value, "id", null)
      type        = lookup(grant.value, "type", null)
      permissions = lookup(grant.value, "permissions", null)
      uri         = lookup(grant.value, "uri", null)
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.sse_enc_defaults
    iterator = i

    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm     = i.value.sse_algorithm
          kms_master_key_id = lookup(i.value, "kms_master_key_id", null)
        }
      }
    }
  }

  versioning {
    enabled    = var.versioning
    mfa_delete = var.mfa_delete
  }

  force_destroy = var.force_destroy

  dynamic "website" {
    for_each = length(var.website) == 0 ? [] : [var.website]

    content {
      index_document = lookup(website.value, "index_document", null)
      error_document = lookup(website.value, "error_document", null)
      redirect_all_requests_to = lookup(website.value, "redirect_all_requests_to", null)
      routing_rules = lookup(website.value, "routing_rules", null)
    }
  }

  tags = {
    Terraform   = "true"
    Environment = var.env
    Project     = var.project
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = var.block_all_public_access ? true : var.block_public_acls
  block_public_policy     = var.block_all_public_access ? true : var.block_public_policy
  restrict_public_buckets = var.block_all_public_access ? true : var.restrict_public_buckets
  ignore_public_acls      = var.block_all_public_access ? true : var.ignore_public_acls
}
