data "aws_route53_zone" "public" {
  name = var.public_dns_name
}

data "aws_vpc" "main" {
  tags = {
    Name = var.env
  }
}

data "aws_subnet_ids" "public_subnets" {
  vpc_id = data.aws_vpc.main.id

  tags = {
    Tier = "public"
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

data "template_file" "user_data" {
  template = file("user_data.sh")
}

module "ec2_web" {
  source = "../../../modules/ec2"

  env  = var.env
  name = "web"

  instance_count = 1

  ami           = "ami-01748a72bed07727c" # amzn2-ami-hvm-2.0.20201218.1-x86_64-gp2
  instance_type = "t3.micro"

  attach_eip         = true
  subnet_ids         = data.aws_subnet_ids.public_subnets.ids
  security_group_ids = [data.aws_security_group.ec2_web.id]

  iam_instance_profile = data.aws_iam_instance_profile.ec2_web.name

  root_volume_size = 30

  user_data_base64 = base64encode(data.template_file.user_data.rendered)

  dns_zone_id = data.aws_route53_zone.public.id
  dns_name    = "${var.env}-web"
}
