data "aws_vpc" "main" {
  tags = {
    Name = var.env
  }
}

data "aws_subnet_ids" "private_subnets" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Tier = "private"
  }
}

data "aws_security_group" "ec2_web" {
  tags = {
    Name = "${var.env}-ec2-web"
  }
}

data "aws_iam_instance_profile" "ec2_web" {
  name = "${var.env}-ec2-web"
}

data "aws_lb_target_group" "web" {
  name = "${var.env}-web"
}

module "asg-web" {
  source = "../../../modules/asg"

  env  = var.env
  name = "web"

  image_id = "ami-041cf17aea0d17496" # https://github.com/megun/packer-samples/blob/master/amzn2.pkr.hcl で作ったやつ

  instance_type        = "t3.micro"
  security_groups      = [data.aws_security_group.ec2_web.id]
  iam_instance_profile = data.aws_iam_instance_profile.ec2_web.name
  subnet_ids           = data.aws_subnet_ids.private_subnets.ids
  health_check_type    = "EC2"
  target_group_arns    = [data.aws_lb_target_group.web.arn]

  #spot_price = "0.004100"

  min_size         = 0
  max_size         = 5
  desired_capacity = 1
}

resource "aws_autoscaling_policy" "web" {
  name                   = "scaling with cpu usage"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = module.asg-web.this_autoscaling_group_name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60.0
  }
}
