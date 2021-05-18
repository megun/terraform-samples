resource "aws_vpc_endpoint" "ssm" {
  for_each = toset([
    "ssm",           # PrivateSubnetからSSM利用する場合必要。fargateの場合は不要
    "ec2messages",   # PrivateSubnetからSSM利用する場合必要。fargateの場合は不要
    "ssmmessages",   # PrivateSubnetからSSM利用する場合必要。fargateの場合は不要
    "ecs-agent",     # PrivateSubnetにECSインスタンス配置する場合必要。fargateの場合は不要
    "ecs-telemetry", # PrivateSubnetにECSインスタンス配置する場合必要。fargateの場合は不要
    "ecs",           # PrivateSubnetにECSインスタンス配置する場合必要。fargateの場合は不要
    "ecr.api",       # PrivateSubnetからECRイメージをPullする場合必要。fargateでも必要(プラットフォームバージョンによる)
    "ecr.dkr",       # PrivateSubnetからECRイメージをPullする場合必要。fargateでも必要
    "logs",          # PrivateSubnetでawslogsログドライバー使用する場合必要。fargateでも必要
  ])

  service_name        = "com.amazonaws.${data.aws_region.current.name}.${each.key}"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  vpc_id              = data.aws_vpc.main.id
  subnet_ids          = data.aws_subnet_ids.private_subnets.ids
  security_group_ids  = [data.aws_security_group.ssm_vpc_endpoint.id]

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.env}-${each.key}"
  })
}

resource "aws_vpc_endpoint" "gateway" {
  for_each = toset([
    "s3", # PrivateSubnetからECRイメージをPullする場合必要。fargateでも必要
  ])

  service_name      = "com.amazonaws.${data.aws_region.current.name}.${each.key}"
  vpc_endpoint_type = "Gateway"
  vpc_id            = data.aws_vpc.main.id
  route_table_ids   = data.aws_route_tables.private.ids

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.env}-${each.key}"
  })
}
