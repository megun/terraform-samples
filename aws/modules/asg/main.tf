resource "null_resource" "create_asg_tags" {
  count = length(keys(merge(var.default_tags, var.tags)))

  triggers = {
    "key"                 = keys(merge(var.default_tags, var.tags))[count.index]
    "value"               = values(merge(var.default_tags, var.tags))[count.index]
    "propagate_at_launch" = true
  }
}

resource "aws_launch_template" "this" {
  name = var.lt_name

  update_default_version = var.update_default_version

  image_id = var.image_id

  vpc_security_group_ids = var.vpc_security_group_ids

  dynamic "iam_instance_profile" {
    for_each = var.iam_instance_profile == null ? [] : [1]
    content {
      name = var.iam_instance_profile
    }
  }

  dynamic "block_device_mappings" {
    for_each = var.block_device_mappings
    iterator = s
    content {
      device_name = s.value.device_name
      dynamic "ebs" {
        for_each = [s.value.ebs]
        content {
          delete_on_termination = lookup(ebs.value, "delete_on_termination", null)
          encrypted             = lookup(ebs.value, "encrypted", null)
          iops                  = lookup(ebs.value, "iops", null)
          snapshot_id           = lookup(ebs.value, "snapshot_id", null)
          throughput            = lookup(ebs.value, "throughput", null)
          volume_size           = lookup(ebs.value, "volume_size", null)
          volume_type           = lookup(ebs.value, "volume_type", null)
        }
      }
    }
  }

  user_data = var.user_data

  tags = merge(var.default_tags, var.tags)
}

resource "aws_autoscaling_group" "this" {
  name = var.asg_name

  max_size         = var.max_size
  min_size         = var.min_size
  desired_capacity = var.desired_capacity

  health_check_type   = var.health_check_type
  vpc_zone_identifier = var.vpc_zone_identifier

  dynamic "mixed_instances_policy" {
    for_each = var.mixed_instances_policy == null ? [] : [var.mixed_instances_policy]
    content {
      dynamic "instances_distribution" {
        for_each = lookup(mixed_instances_policy.value, "instances_distribution", null) == null ? [] : [mixed_instances_policy.value.instances_distribution]
        iterator = i
        content {
          on_demand_allocation_strategy            = lookup(i.value, "on_demand_allocation_strategy", null)
          on_demand_base_capacity                  = lookup(i.value, "on_demand_base_capacity", null)
          on_demand_percentage_above_base_capacity = lookup(i.value, "on_demand_percentage_above_base_capacity", null)
          spot_allocation_strategy                 = lookup(i.value, "spot_allocation_strategy", null)
          spot_instance_pools                      = lookup(i.value, "spot_instance_pools", null)
          spot_max_price                           = lookup(i.value, "spot_max_price", null)
        }
      }
      launch_template {
        launch_template_specification {
          launch_template_id = aws_launch_template.this.id
          version            = "$Default"
        }
        dynamic "override" {
          for_each = lookup(mixed_instances_policy.value, "override", null) == null ? [] : mixed_instances_policy.value.override
          content {
            instance_type     = lookup(override.value, "instance_type", null)
            weighted_capacity = lookup(override.value, "weighted_capacity", null)
            dynamic "launch_template_specification" {
              for_each = lookup(override.value, "launch_template_specification", null) == null ? [] : [override.value.launch_template_specification]
              iterator = ol
              content {
                launch_template_id = lookup(ol.value, "launch_template_id", null)
                version            = lookup(ol.value, "version", null)
              }
            }
          }
        }
      }
    }
  }

  protect_from_scale_in = var.protect_from_scale_in

  tags = concat(
    null_resource.create_asg_tags.*.triggers,
  )
}
