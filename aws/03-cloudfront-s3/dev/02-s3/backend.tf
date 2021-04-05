terraform {
  backend "s3" {
    bucket         = "megun-terraform-samples-tfstate-dev"
    key            = "03-cloudfront-s3/s3.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "megun-terraform-samples-tflock-dev"
  }
}