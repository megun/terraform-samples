terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.31.0 "
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 2.1.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "http" {
}
