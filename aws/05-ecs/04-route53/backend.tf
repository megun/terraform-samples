terraform {
  backend "s3" {
    bucket         = "megun-terraform-samples-tfstate2-prod"
    key            = "05-ecs/route53.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "megun-terraform-samples-tflock-prod"

    profile = "megun002"
  }
}
