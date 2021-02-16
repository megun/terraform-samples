terraform {
  backend "s3" {
    bucket         = "megun-terraform-samples-tfstate-prod"
    key            = "02-ec2-autoscale/alb.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "megun-terraform-samples-tflock-prod"
  }
}
