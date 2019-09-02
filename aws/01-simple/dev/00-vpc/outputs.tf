output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.dev_vpc.vpc_id
}

output "public_subnets" {
  description = "The ID of the public subnets "
  value       = module.dev_vpc.public_subnets
}
