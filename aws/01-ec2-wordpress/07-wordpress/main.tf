### IAM
module "iam_role_ec2_wordpress" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "4.24.0"

  create_role             = true
  create_instance_profile = true

  role_name = "${var.project}-${var.env}-wordpress"

  custom_role_policy_arns = concat(var.custom_role_policy_arns, [module.iam_policy_ssm_sendcommand.arn, module.iam_policy_ssm_parameterstore.arn])

  trusted_role_services = ["ec2.amazonaws.com"]

  role_requires_mfa = false
}

module "iam_policy_ssm_sendcommand" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "4.24.0"

  name = "ssm_sendcommand"
  path = "/"

  policy = data.aws_iam_policy_document.ssm_sendcommand.json
}

module "iam_policy_ssm_parameterstore" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "4.24.0"

  name = "ssm_parameterstore"
  path = "/"

  policy = data.aws_iam_policy_document.ssm_parameterstore.json
}

### AutoScalingGroup
module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "6.3.0"

  name = "${var.project}-${var.env}-asg"

  min_size = var.min_size
  max_size = var.max_size
  #desired_capacity = var.desired_capacity

  health_check_type = var.health_check_type

  vpc_zone_identifier = data.aws_subnets.private_subnets.ids
  security_groups     = [data.aws_security_group.wordpress.id]
  target_group_arns   = [data.aws_lb_target_group.alb.arn]

  # Launch template
  launch_template_name   = "${var.project}-${var.env}-asg"
  update_default_version = true

  image_id          = var.image_id
  instance_type     = var.instance_type
  enable_monitoring = false

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = var.root_volume_size
        volume_type           = "gp3"
      }
    }
  ]

  instance_market_options = {
    market_type = "spot"
  }

  iam_instance_profile_name = "${var.project}-${var.env}-wordpress"

  user_data = base64encode(data.template_file.user_data.rendered)
}
