output "service_arn_front" {
  value = aws_service_discovery_service.service["frontend"].arn
}

output "service_arn_back" {
  value = aws_service_discovery_service.service["backend"].arn
}
