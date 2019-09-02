data "aws_route53_zone" "local" {
  name         = "${var.env}.local"
  private_zone = true
}

data "aws_vpc" "main" {
  tags = {
    Name = var.env
  }
}

data "aws_subnet_ids" "db_subnets" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Tier = "database"
  }
}

data "aws_security_group" "aurora_mysql" {
  tags = {
    Name = "${var.env}-rds-mysql"
  }
}

module "aurora_mysql" {
  source = "../../../modules/aurora_mysql"

  env  = var.env
  name = "aurora-mysql"

  engine_version = "5.7.mysql_aurora.2.09.1"

  vpc_id             = data.aws_vpc.main.id
  subnet_ids         = data.aws_subnet_ids.db_subnets.ids
  security_group_ids = [data.aws_security_group.aurora_mysql.id]

  replica_count = 1

  instance_type = "db.t3.small"

  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  database_name = "hogedb"
  username      = "root"

  preferred_backup_window      = "06:00-07:00"
  preferred_maintenance_window = "mon:07:00-mon:08:00"

  dns_zone_id = data.aws_route53_zone.local.id

  cluster_parameters = [
    {
      name         = "character_set_server"
      value        = "utf8mb4"
      apply_method = "immediate"
    },
    {
      name         = "character_set_client"
      value        = "utf8mb4"
      apply_method = "immediate"
    },
  ]

  #db_parameters = [
  #  {
  #    name         = "max_connections"
  #    value        = "10000"
  #    apply_method = "immediate"
  #  },
  #]
}
