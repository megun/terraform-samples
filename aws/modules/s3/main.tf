resource "aws_s3_bucket" "this" {
  bucket = var.name
  acl    = var.acl

  tags = {
    Name        = var.name
    Environment = var.env
    Project = var.project
  }
}
