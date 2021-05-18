resource "aws_route53_zone" "private" {
  name = local.domain_name_private

  vpc {
    vpc_id = data.aws_vpc.main.id
  }

  tags = local.common_tags
}
