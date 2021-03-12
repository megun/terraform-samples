data "aws_route53_zone" "local" {
  name         = "${var.project}-${var.env}.local"
  private_zone = true
}

data "aws_vpc" "main" {
  tags = {
    Name = "${var.project}-${var.env}"
  }
}

data "aws_subnet_ids" "db_subnets" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Tier = "database"
  }
}

data "aws_security_group" "elasticache_memcached" {
  tags = {
    Name = "${var.project}-${var.env}-elasticache-memcached"
  }
}


module "elasticache_memcached" {
  source = "../../../modules/elasticache_memcached/"

  project = var.project
  env     = var.env
  name    = "memcached"

  node_type       = "cache.t3.micro"
  engine_version  = "1.6.6"
  num_cache_nodes = 1

  subnet_ids         = data.aws_subnet_ids.db_subnets.ids
  security_group_ids = [data.aws_security_group.elasticache_memcached.id]

  maintenance_window = "mon:07:00-mon:08:00"

  dns_zone_id = data.aws_route53_zone.local.id

  parameters = [
    {
      name  = "idle_timeout"
      value = "3600"
    },
  ]
}
