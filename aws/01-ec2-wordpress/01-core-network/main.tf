### VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "v3.14.0"

  name = "${var.project}-${var.env}"
  cidr = var.cidr

  azs              = var.azs
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets

  enable_dns_hostnames = true

  enable_nat_gateway     = var.enable_nat_gateway
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

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

/* 
### VPC Endpoint
resource "aws_vpc_endpoint" "interface" {
  for_each = toset([
    "ssm",         # PrivateSubnetからSSM利用する場合必要。fargateの場合は不要
    "ec2messages", # PrivateSubnetからSSM利用する場合必要。fargateの場合は不要
    "ssmmessages", # PrivateSubnetからSSM利用する場合必要。fargateの場合は不要
  ])

  service_name        = "com.amazonaws.${data.aws_region.current.name}.${each.key}"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  vpc_id              = data.aws_vpc.main.id
  subnet_ids          = data.aws_subnet_ids.private_subnets.ids
  security_group_ids  = [data.aws_security_group.ssm_vpc_endpoint.id]

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.env}-${each.key}"
  })
}
*/


### Route53 Public Zone
resource "aws_route53_zone" "public" {
  name = "${var.env}-${var.project}.megunlabo.net"
}

### Route53 Private Zone
resource "aws_route53_zone" "private" {
  name = "${var.env}-${var.project}.local"

  vpc {
    vpc_id = module.vpc.vpc_id
  }
}

### ACM
module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "3.4.1"

  domain_name = "${var.env}-${var.project}.megunlabo.net"
  zone_id     = aws_route53_zone.public.zone_id

  subject_alternative_names = [
    "*.${var.env}-${var.project}.megunlabo.net",
  ]

  wait_for_validation = true
}
