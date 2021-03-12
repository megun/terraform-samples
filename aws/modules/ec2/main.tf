resource "aws_eip" "this" {
  count = var.attach_eip ? var.instance_count : 0

  vpc      = true
  instance = module.ec2_instance.id[count.index]

  tags = {
    Name        = var.instance_count > 1 ? format("%s-%s-ec2-%s-%d", var.project, var.env, var.name, count.index + 1) : "${var.project}-${var.env}-ec2-${var.name}"
    Terraform   = "true"
    Environment = var.env
    Project     = var.project
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.16.0"

  name           = "${var.project}-${var.env}-${var.name}"
  instance_count = var.instance_count

  ami           = var.ami
  instance_type = var.instance_type

  vpc_security_group_ids = var.security_group_ids
  subnet_ids             = var.subnet_ids
  iam_instance_profile   = var.iam_instance_profile

  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = var.root_volume_size
    },
  ]

  user_data_base64 = var.user_data_base64

  tags = {
    Terraform   = "true"
    Environment = var.env
    Project     = var.project
  }
}

resource "aws_route53_record" "this" {
  count = var.dns_zone_id != null && var.attach_eip ? 1 : 0

  zone_id = var.dns_zone_id
  name    = var.dns_name
  type    = "A"
  ttl     = 60
  records = aws_eip.this[*].public_ip
}
