output "iam_role_arn_ec2_web" {
  description = "The ID of the ec2 web"
  value       = module.iam_role_ec2_web.iam_role_arn
}

output "iam_instance_profile_name_ec2_web" {
  description = "The ID of the ec2 web"
  value       = module.iam_role_ec2_web.iam_instance_profile_name
}
