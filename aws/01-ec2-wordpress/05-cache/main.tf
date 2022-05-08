resource "aws_elasticache_subnet_group" "memcached" {
  name       = "${var.project}-${var.env}-memcached"
  subnet_ids = data.aws_subnets.db_subnets.ids
}

resource "aws_elasticache_parameter_group" "memcached" {
  name   = "${var.project}-${var.env}-memcached"
  family = "memcached${regex("[0-9]+.[0-9]+", var.engine_version)}"
}

resource "aws_elasticache_cluster" "memcached" {
  cluster_id           = "${var.project}-${var.env}-memcached"
  engine               = "memcached"
  engine_version       = var.engine_version
  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes
  parameter_group_name = aws_elasticache_parameter_group.memcached.id
  port                 = 11211
  subnet_group_name    = aws_elasticache_subnet_group.memcached.id
  security_group_ids   = [data.aws_security_group.memcached.id]
  az_mode              = var.num_cache_nodes > 1 ? "cross-az" : "single-az"
  maintenance_window   = var.maintenance_window
  apply_immediately    = true
}

resource "aws_route53_record" "memcached" {
  zone_id = data.aws_route53_zone.local.zone_id
  name    = "memcached"
  type    = "CNAME"
  ttl     = 30
  records = [aws_elasticache_cluster.memcached.cluster_address]
}
