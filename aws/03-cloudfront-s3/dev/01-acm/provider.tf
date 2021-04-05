terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.31.0 "
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  region = "ap-northeast-1"
  alias  = "route53"
}
