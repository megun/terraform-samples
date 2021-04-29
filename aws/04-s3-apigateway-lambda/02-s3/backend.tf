terraform {
  backend "s3" {
    bucket         = "megun-terraform-samples-tfstate2-prod"
    key            = "04-s3-apigateway-lambda/s3.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "megun-terraform-samples-tflock-prod"

    profile = "megun002"
  }
}
