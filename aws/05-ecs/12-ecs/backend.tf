terraform {
  backend "s3" {
    bucket         = "megun-terraform-samples-tfstate2-prod"
    key            = "05-ecs/ecs.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "megun-terraform-samples-tflock-prod"

    profile = "megun002"
  }
}

data "terraform_remote_state" "cloudmap" {
  backend = "s3"

  config = {
    bucket  = "megun-terraform-samples-tfstate2-prod"
    key     = "05-ecs/cloudmap.tfstate"
    region  = "ap-northeast-1"
    profile = "megun002"
  }
}
