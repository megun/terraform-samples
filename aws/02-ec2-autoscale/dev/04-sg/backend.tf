terraform {
  backend "s3" {
    bucket         = "megun-terraform-samples-tfstate-dev"
    key            = "02-ec2-autoscale/sg.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "megun-terraform-samples-tflock-dev"
  }
}
