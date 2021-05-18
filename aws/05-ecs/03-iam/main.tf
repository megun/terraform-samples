module "iam_role_ecs_instance" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "4.1.0"

  create_role             = true
  create_instance_profile = true

  role_name = local.iam_role_ecs_instance_name

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  trusted_role_services = ["ec2.amazonaws.com"]

  role_requires_mfa = false

  tags = local.common_tags
}

module "iam_role_ecs_execution" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
  version = "4.1.0"

  create_role = true

  role_name = local.iam_role_ecs_execution_name

  custom_role_policy_arns = [
    aws_iam_policy.parameterstore.arn,
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ]

  trusted_role_services = ["ecs-tasks.amazonaws.com"]

  role_requires_mfa = false

  tags = local.common_tags
}

resource "aws_iam_policy" "parameterstore" {
  name   = "${var.project}-${var.env}-parameterstore"
  path   = "/"
  policy = data.aws_iam_policy_document.parameterstore.json
}

# 管理画面からポチポチやってたら作成されてるはず。
resource "aws_iam_service_linked_role" "ecs" {
  aws_service_name = "ecs.application-autoscaling.amazonaws.com"
}
