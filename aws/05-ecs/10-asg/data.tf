data "aws_security_group" "ecs_instance" {
  tags = {
    Name = "${var.project}-${var.env}-ecs-instance"
  }
}

data "aws_iam_instance_profile" "ecsInstanceRole" {
  name = local.iam_role_ecs_instance_name
}

data "aws_ssm_parameter" "ecs_ami_id" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}
