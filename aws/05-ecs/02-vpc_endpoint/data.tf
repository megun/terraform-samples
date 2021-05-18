data "aws_security_group" "ssm_vpc_endpoint" {
  tags = {
    Name = "${var.project}-${var.env}-ssm-vpc-endpoint"
  }
}
