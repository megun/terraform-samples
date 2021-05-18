data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "aws_vpc" "main" {
  tags = {
    Name = "${var.project}-${var.env}"
  }
}

data "aws_route_tables" "private" {
  vpc_id = data.aws_vpc.main.id
  filter {
    name   = "tag:Name"
    values = ["${var.project}-${var.env}-private-*"]
  }
}

data "aws_subnet_ids" "public_subnets" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Tier = "public"
  }
}

data "aws_subnet_ids" "private_subnets" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Tier = "private"
  }
}

data "aws_subnet_ids" "database_subnets" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Tier = "database"
  }
}
