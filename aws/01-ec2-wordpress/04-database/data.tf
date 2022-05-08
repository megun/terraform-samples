data "aws_vpc" "vpc" {
  tags = {
    Name = "${var.project}-${var.env}"
  }
}

data "aws_route53_zone" "local" {
  name         = "${var.env}-${var.project}.local"
  private_zone = true
}

data "aws_subnets" "db_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  tags = {
    Tier = "database"
  }
}

data "aws_security_group" "aurora-mysql" {
  tags = {
    Name = "${var.project}-${var.env}-aurora-mysql"
  }
}
