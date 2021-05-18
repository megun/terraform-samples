module "asg" {
  source = "../../modules/asg"

  # Launch template
  lt_name = "${var.project}-${var.env}-ecs"
  block_device_mappings = [
    {
      device_name = "/dev/xvda"
      ebs = {
        volume_type = "gp3"
        volume_size = 30
        encrypted   = true
      }
    }
  ]
  iam_instance_profile   = data.aws_iam_instance_profile.ecsInstanceRole.name
  image_id               = data.aws_ssm_parameter.ecs_ami_id.value
  vpc_security_group_ids = [data.aws_security_group.ecs_instance.id]
  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    ecs_clster = "${var.project}-${var.env}-cluster",
  }))

  # Auto scaling group
  asg_name         = "${var.project}-${var.env}-ecs"
  max_size         = 5
  min_size         = 0
  desired_capacity = 0

  vpc_zone_identifier = data.aws_subnet_ids.private_subnets.ids

  health_check_type = "EC2"

  mixed_instances_policy = {
    instances_distribution = {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 0
      spot_allocation_strategy                 = "capacity-optimized"
    }
    override = [
      {
        instance_type = "c5.large"
        #weighted_capacity = "2"
      },
      {
        instance_type = "c5a.large"
        #weighted_capacity = "2"
      }
    ]
  }

  protect_from_scale_in = true

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.env}-ecs"
  })
}
