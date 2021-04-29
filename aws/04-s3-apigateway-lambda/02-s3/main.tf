module "s3_hosting" {
  source = "../../modules/s3"

  name = var.s3_hosting_bucket_name
  #acl    = "public-read"
  policy = data.aws_iam_policy_document.s3_hosting.json

  website = {
    index_document = "index.html"
  }

  force_destroy = true
}

resource "null_resource" "upload_contents" {
  triggers = {
    now_date = timestamp()
  }

  provisioner "local-exec" {
    command = "aws s3 cp --quiet ../app/static/* s3://${var.s3_hosting_bucket_name} --profile megun002"
  }

  depends_on = [
    module.s3_hosting
  ]
}
