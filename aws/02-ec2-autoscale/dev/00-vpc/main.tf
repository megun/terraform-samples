module "dev_vpc" {
  source = "../../../modules/vpc"

  project         = var.project
  env             = var.env
  cidr            = "10.0.0.0/16"
  azs             = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  public_subnets  = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
  private_subnets = ["10.0.64.0/20", "10.0.80.0/20", "10.0.96.0/20"]

  enable_nat_gateway = true
  single_nat_gateway = true
  #one_nat_gateway_per_az = true
}
