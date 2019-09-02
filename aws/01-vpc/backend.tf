terraform {
  backend "s3" {
    bucket = "megun-terraform-samples-12"
    key    = "terraform.tfstate/VPC"
    workspace_key_prefix = "env"
    region = "ap-northeast-1"
  }
}
