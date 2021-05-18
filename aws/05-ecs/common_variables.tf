locals {
  common_tags = {
    Terraform   = "true"
    Project     = var.project
    Environment = var.env
  }
  iam_role_ecs_instance_name  = "${var.project}-${var.env}-ec2-ecsInstanceRole"
  iam_role_ecs_execution_name = "${var.project}-${var.env}-ecs-ecsTaskExecutionRole"
  domain_name_private         = "${var.project}-${var.env}.local"
  db_hostname_full            = "${var.db_hostname}.${local.domain_name_private}"
}

variable "assume_role" {
  type = string
}

variable "project" {
  type    = string
  default = "ecs"
}

variable "env" {
  type    = string
  default = "prod"
}

variable "domain_name" {
  type    = string
  default = "demo.megunlabo.net"
}

variable "domain_hostname" {
  type    = string
  default = "ecs-sample"
}

variable "domain_name_sd" {
  type    = string
  default = "local"
}

variable "domain_name_private" {
  type    = string
  default = "local"
}

variable "ecr_name_frontend" {
  type    = string
  default = "sample1/front-nginx"
}

variable "ecr_name_backend" {
  type    = string
  default = "sample1/back-go"
}

variable "path_sample_app_frontend" {
  type    = string
  default = "../../../sample-apps/sample1/front-nginx"
}

variable "path_sample_app_backend" {
  type    = string
  default = "../../../sample-apps/sample1/back-go"
}

variable "db_hostname" {
  type    = string
  default = "aurora-mysql"
}

variable "db_port" {
  type    = number
  default = 3306
}

variable "db_name" {
  type    = string
  default = "hogedb"
}

variable "db_user" {
  type    = string
  default = "root"
}

variable "backend_host" {
  type    = string
  default = "backend.local"
}

variable "backend_port" {
  type    = number
  default = 8080
}

variable "cw_loggroup_frontend" {
  type    = string
  default = "/ecs/frontend"
}

variable "cw_loggroup_backend" {
  type    = string
  default = "/ecs/backend"
}
