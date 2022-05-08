data "http" "ifconfig" {
  url = "https://ifconfig.io/ip"
}

data "aws_vpc" "main" {
  tags = {
    Name = "${var.project}-${var.env}"
  }
}

module "security_group_alb" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name        = "${var.project}-${var.env}-alb"
  description = "Security group for alb"
  vpc_id      = data.aws_vpc.main.id

  ingress_cidr_blocks = concat(var.allow_ips_wordpress, local.myip)
  ingress_rules       = ["https-443-tcp"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]
}

module "security_group_wordpress" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name        = "${var.project}-${var.env}-wordpress"
  description = "Security group for wordpress"
  vpc_id      = data.aws_vpc.main.id

  ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.security_group_alb.security_group_id
    },
  ]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]
}

module "security_group_aurora-mysql" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name        = "${var.project}-${var.env}-aurora-mysql"
  description = "Security group for aurora-mysql"
  vpc_id      = data.aws_vpc.main.id

  ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.security_group_wordpress.security_group_id
    },
  ]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]
}

module "security_group_memcached" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.9.0"

  name        = "${var.project}-${var.env}-memcached"
  description = "Security group for memcached"
  vpc_id      = data.aws_vpc.main.id

  ingress_with_source_security_group_id = [
    {
      rule                     = "memcached-tcp"
      source_security_group_id = module.security_group_wordpress.security_group_id
    },
  ]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]
}
