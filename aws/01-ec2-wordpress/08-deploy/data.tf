data "aws_autoscaling_groups" "wordpress" {
  filter {
    name   = "tag:Name"
    values = ["${var.project}-${var.env}-asg"]
  }
}

data "aws_lb_target_group" "wordpress" {
  name = "${var.project}-${var.env}-wordpress"
}
