output "iam_role_arn" {
  description = "The ID of the ec2 web"
  value       = module.iam_role_ec2.iam_role_arn
}

output "iam_instance_profile_name" {
  description = "The ID of the ec2 web"
  value       = module.iam_role_ec2.iam_instance_profile_name
}
