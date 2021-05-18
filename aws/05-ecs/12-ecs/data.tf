data "aws_ecr_repository" "frontend" {
  name = var.ecr_name_frontend
}

data "aws_ecr_repository" "backend" {
  name = var.ecr_name_backend
}

data "aws_iam_role" "ecs_task_execution" {
  name = local.iam_role_ecs_execution_name
}

data "aws_security_group" "ecs_nginx" {
  tags = {
    Name = "${var.project}-${var.env}-ecs-nginx"
  }
}

data "aws_security_group" "ecs_go" {
  tags = {
    Name = "${var.project}-${var.env}-ecs-go"
  }
}

data "aws_alb_target_group" "ecs" {
  tags = {
    Name = "${var.project}-${var.env}-ecs"
  }
}

data "aws_autoscaling_group" "ecs" {
  name = "${var.project}-${var.env}-ecs"
}
