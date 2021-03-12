module "dev_vpc" {
  source = "../../../modules/vpc"

  project          = var.project
  env              = var.env
  cidr             = "10.0.0.0/16"
  azs              = ["ap-northeast-1a", "ap-northeast-1c"]
  public_subnets   = ["10.0.0.0/20"]
  database_subnets = ["10.0.64.0/20", "10.0.80.0/20"]
}
