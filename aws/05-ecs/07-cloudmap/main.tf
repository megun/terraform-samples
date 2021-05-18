resource "aws_service_discovery_private_dns_namespace" "sd" {
  name = var.domain_name_sd
  vpc  = data.aws_vpc.main.id
}

resource "aws_service_discovery_service" "service" {
  for_each = toset([
    "frontend",
    "backend",
  ])

  name = each.key

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.sd.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}
