locals {
  myip = [format("%s/32", chomp(data.http.ifconfig.body))]
}

module "security-group_alb" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.0.0"

  name        = "${var.project}-${var.env}-alb"
  description = "Security group for alb"
  vpc_id      = data.aws_vpc.main.id

  ingress_cidr_blocks = local.myip
  ingress_rules       = ["https-443-tcp"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = local.common_tags
}

module "security-group_ssm_vpc_endopint" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.0.0"

  name        = "${var.project}-${var.env}-ssm-vpc-endpoint"
  description = "Security group for ssm vpc endopoint"
  vpc_id      = data.aws_vpc.main.id

  ingress_cidr_blocks = [data.aws_vpc.main.cidr_block]
  ingress_rules       = ["https-443-tcp"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = local.common_tags
}

module "security-group_ecs_instance" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.0.0"

  name        = "${var.project}-${var.env}-ecs-instance"
  description = "Security group for ecs instance"
  vpc_id      = data.aws_vpc.main.id

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = local.common_tags
}

module "security-group_ecs_nginx" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.0.0"

  name        = "${var.project}-${var.env}-ecs-nginx"
  description = "Security group for ecs nginx"
  vpc_id      = data.aws_vpc.main.id

  ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.security-group_alb.security_group_id
    },
  ]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = local.common_tags
}

module "security-group_ecs_go" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.0.0"

  name        = "${var.project}-${var.env}-ecs-go"
  description = "Security group for ecs go"
  vpc_id      = data.aws_vpc.main.id

  ingress_with_source_security_group_id = [
    {
      rule                     = "http-8080-tcp"
      source_security_group_id = module.security-group_ecs_nginx.security_group_id
    },
  ]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = local.common_tags
}

module "security-group_aurora_mysql" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.0.0"

  name        = "${var.project}-${var.env}-aurora-mysql"
  description = "Security group for aurora mysql"
  vpc_id      = data.aws_vpc.main.id

  ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.security-group_ecs_go.security_group_id
    },
  ]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = local.common_tags
}
