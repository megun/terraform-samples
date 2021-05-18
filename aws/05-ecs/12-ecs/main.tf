resource "aws_ecs_cluster" "cluster" {
  name = "${var.project}-${var.env}-cluster"

  capacity_providers = [aws_ecs_capacity_provider.ecs.name, "FARGATE_SPOT"]
  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs.name
    base              = 1
    weight            = 1
  }

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Terraform   = "true"
    Environment = var.env
    Project     = var.project
  }
}

resource "aws_ecs_capacity_provider" "ecs" {
  name = "sample"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = data.aws_autoscaling_group.ecs.arn
    managed_termination_protection = "ENABLED"

    managed_scaling {
      maximum_scaling_step_size = 5
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
}

resource "aws_ecs_task_definition" "frontend" {
  family = "frontend"
  #cpu    = 256
  #memory = 512

  task_role_arn      = null
  execution_role_arn = data.aws_iam_role.ecs_task_execution.arn

  network_mode = "awsvpc"

  container_definitions = templatefile("${path.module}/ecs-task-nginx.json", {
    ecr_repository_url = data.aws_ecr_repository.frontend.repository_url,
    backend_host       = var.backend_host,
    backend_port       = var.backend_port,
  })
}

resource "aws_ecs_task_definition" "backend" {
  family = "backend"
  cpu    = 256
  memory = 512

  task_role_arn      = null
  execution_role_arn = data.aws_iam_role.ecs_task_execution.arn

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  container_definitions = templatefile("${path.module}/ecs-task-go.json", {
    ecr_repository_url  = data.aws_ecr_repository.backend.repository_url,
    cw_loggroup_backend = var.cw_loggroup_backend,
    backend_port        = var.backend_port,
    db_host             = local.db_hostname_full,
    db_port             = var.db_port,
    db_name             = var.db_name,
    db_user             = var.db_user,
    db_pass_path        = "/${var.project}-${var.env}/${var.db_hostname}/master_pass",
  })
}

resource "aws_ecs_service" "frontend" {
  name    = "frontend"
  cluster = aws_ecs_cluster.cluster.id
  #launch_type         = "EC2"
  task_definition     = aws_ecs_task_definition.frontend.arn
  desired_count       = 1
  scheduling_strategy = "REPLICA"

  network_configuration {
    subnets         = data.aws_subnet_ids.private_subnets.ids
    security_groups = [data.aws_security_group.ecs_nginx.id]
  }

  service_registries {
    registry_arn = data.terraform_remote_state.cloudmap.outputs.service_arn_front
  }

  load_balancer {
    target_group_arn = data.aws_alb_target_group.ecs.arn
    container_name   = "front-nginx"
    container_port   = 80
  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs.name
    base              = 1
    weight            = 1
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}

resource "aws_ecs_service" "backend" {
  name    = "backend"
  cluster = aws_ecs_cluster.cluster.id
  #launch_type         = "EC2"
  task_definition     = aws_ecs_task_definition.backend.arn
  desired_count       = 1
  scheduling_strategy = "REPLICA"

  network_configuration {
    subnets         = data.aws_subnet_ids.private_subnets.ids
    security_groups = [data.aws_security_group.ecs_go.id]
  }

  service_registries {
    registry_arn = data.terraform_remote_state.cloudmap.outputs.service_arn_back
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    base              = 1
    weight            = 1
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}

resource "aws_appautoscaling_target" "frontend" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.frontend.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "frontend" {
  name               = "TargetTracking"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.frontend.resource_id
  scalable_dimension = aws_appautoscaling_target.frontend.scalable_dimension
  service_namespace  = aws_appautoscaling_target.frontend.service_namespace

  ### CPU平均使用率を70%に維持する
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 70
  }
}

resource "aws_appautoscaling_target" "backend" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.backend.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "backend" {
  name               = "TargetTracking"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.backend.resource_id
  scalable_dimension = aws_appautoscaling_target.backend.scalable_dimension
  service_namespace  = aws_appautoscaling_target.backend.service_namespace

  ### CPU平均使用率を70%に維持する
  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 70
  }
}
