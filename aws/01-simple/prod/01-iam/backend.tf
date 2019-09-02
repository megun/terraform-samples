terraform {
  backend "s3" {
    bucket         = "megun-terraform-samples-tfstate-prod"
    key            = "01-simple/iam.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "megun-terraform-samples-tflock-prod"
  }
}
