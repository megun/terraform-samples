terraform {
  backend "s3" {
    bucket         = "megun-terraform-samples-tfstate2-prod"
    key            = "03-cloudfront-s3/wafv2.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "megun-terraform-samples-tflock-prod"

    # 変数が使えなかったのでprofile指定する
    #role_arn = var.assume_role
    profile = "megun002"
  }
}
