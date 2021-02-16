module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "3.8.0"

  name = "${var.env}-${var.name}"

  # Launch configuration
  lc_name = "${var.env}-${var.name}"

  image_id             = var.image_id
  instance_type        = var.instance_type
  security_groups      = var.security_groups
  iam_instance_profile = var.iam_instance_profile

  spot_price = var.spot_price == null ? null : var.spot_price

  enable_monitoring = var.enable_monitoring

  root_block_device = [
    {
      volume_size = var.root_volume_size
      volume_type = var.root_volume_type
    },
  ]

  # Auto scaling group
  asg_name                  = "${var.env}-${var.name}"
  vpc_zone_identifier       = var.subnet_ids
  health_check_type         = var.health_check_type
  target_group_arns         = var.target_group_arns
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  wait_for_capacity_timeout = var.wait_for_capacity_timeout

  tags_as_map = {
    Environment = var.env
    Terraform   = "true"
  }
}

resource "aws_autoscaling_schedule" "this" {
  for_each = { for schedule in var.schedules : schedule.scheduled_action_name => schedule }

  scheduled_action_name = each.value.scheduled_action_name
  min_size              = each.value.min_size
  max_size              = each.value.max_size
  desired_capacity      = each.value.desired_capacity

  recurrence             = each.value.schedule
  autoscaling_group_name = module.asg.this_autoscaling_group_name
}


/*
module "asg_schedule_web" {
  source = "./schedule"

  up_min_size         = 1
  up_max_size         = 5
  up_desired_capacity = 1

  down_schedule = "0 1 * * *"
  up_schedule   = "0 0 * * *"

  autoscaling_group_name = module.asg-web.this_autoscaling_group_name
}
*/
