data "aws_vpc" "main" {
  tags = {
    Name = "${var.project}-${var.env}"
  }
}

module "security-group_ec2_web" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.17.0"

  name        = "${var.project}-${var.env}-ec2-web"
  description = "Security group for web"
  vpc_id      = data.aws_vpc.main.id

  ingress_cidr_blocks = var.developper_ips #["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = {
    Terraform   = "true"
    Environment = var.env
    Project     = var.project
  }
}

module "security-group_rds_mysql" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.17.0"

  name        = "${var.project}-${var.env}-rds-mysql"
  description = "Security group for mysql"
  vpc_id      = data.aws_vpc.main.id

  ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.security-group_ec2_web.this_security_group_id
    },
  ]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = {
    Terraform   = "true"
    Environment = var.env
    Project     = var.project
  }
}

module "security-group_elasticache_memcached" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.17.0"

  name        = "${var.project}-${var.env}-elasticache-memcached"
  description = "Security group for memcached"
  vpc_id      = data.aws_vpc.main.id

  ingress_with_source_security_group_id = [
    {
      rule                     = "memcached-tcp"
      source_security_group_id = module.security-group_ec2_web.this_security_group_id
    },
  ]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = {
    Terraform   = "true"
    Environment = var.env
    Project     = var.project
  }
}
