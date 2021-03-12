resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.project}-${var.env}-${var.name}"
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_parameter_group" "this" {
  name   = "${var.project}-${var.env}-${var.name}"
  family = "memcached${regex("[0-9]+.[0-9]+", var.engine_version)}"

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }
}

resource "aws_elasticache_cluster" "this" {
  cluster_id           = "${var.project}-${var.env}-${var.name}"
  engine               = "memcached"
  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes
  parameter_group_name = aws_elasticache_parameter_group.this.id
  port                 = 11211
  subnet_group_name    = aws_elasticache_subnet_group.this.id
  security_group_ids   = var.security_group_ids
  az_mode              = var.num_cache_nodes > 1 ? "cross-az" : "single-az"
  maintenance_window   = var.maintenance_window
  apply_immediately    = true

  tags = {
    Name        = "${var.env}-${var.name}"
    Terraform   = "true"
    Environment = var.env
    Project     = var.project
  }
}

resource "aws_route53_record" "this" {
  count = var.dns_zone_id != null ? 1 : 0

  zone_id = var.dns_zone_id
  name    = var.name
  type    = "CNAME"
  ttl     = 30
  records = [aws_elasticache_cluster.this.cluster_address]
}
