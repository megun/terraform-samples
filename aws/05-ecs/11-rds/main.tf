module "aurora-mysql" {
  source = "../../modules/aurora_mysql"

  project = var.project
  env     = var.env
  name    = var.db_hostname

  engine_mode    = "serverless"
  engine_version = "5.7.mysql_aurora.2.07.1"

  vpc_id             = data.aws_vpc.main.id
  subnet_ids         = data.aws_subnet_ids.database_subnets.ids
  security_group_ids = [data.aws_security_group.aurora_mysql.id]

  replica_count = 0 # for serverless, 0

  database_name = var.db_name
  username      = var.db_user

  preferred_backup_window      = "06:00-07:00"
  preferred_maintenance_window = "mon:07:00-mon:08:00"

  dns_zone_id = data.aws_route53_zone.local.id

  enable_http_endpoint = true

  scaling_configuration = {
    max_capacity = 4
    min_capacity = 1
  }

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

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.env}-${var.db_hostname}"
  })
}
