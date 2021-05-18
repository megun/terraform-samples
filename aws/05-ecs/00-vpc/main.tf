module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "v3.0.0"

  name = "${var.project}-${var.env}"
  cidr = "10.0.0.0/16"

  azs              = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  public_subnets   = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
  private_subnets  = ["10.0.64.0/20", "10.0.80.0/20", "10.0.96.0/20"]
  database_subnets = ["10.0.128.0/20", "10.0.144.0/20", "10.0.160.0/20"]

  enable_dns_hostnames = true

  tags = local.common_tags

  public_subnet_tags = {
    Tier = "public"
  }

  private_subnet_tags = {
    Tier = "private"
  }

  database_subnet_tags = {
    Tier = "database"
  }
}
