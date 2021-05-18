module "iam_role_ec2" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "4.1.0"

  create_role             = true
  create_instance_profile = true

  role_name = "${var.project}-${var.env}-ec2-${var.role_name}"

  custom_role_policy_arns = var.attach_policies
  #number_of_custom_role_policy_arns = 2

  trusted_role_services = ["ec2.amazonaws.com"]

  role_requires_mfa = false

  tags = {
    Terraform   = "true"
    Project     = var.project
    Environment = var.env
  }
}
