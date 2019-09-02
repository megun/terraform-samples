# Subnets
variable "azs" {
  description = "A list of availability zones in which to create subnets"
  type = list(string)
  default = [
    "ap-northeast-1a",
    "ap-northeast-1c",
    "ap-northeast-1d",
  ]
}

resource "aws_subnet" "subnet-pub" {
  count = length(var.azs)

  vpc_id     = "${aws_vpc.vpc.id}"
  availability_zone = var.azs[count.index]
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 4, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "${terraform.workspace}-subnet-${substr(var.azs[count.index], 13, 2)}-pub"
  }
}

resource "aws_subnet" "subnet-pri" {
  count = length(var.azs)

  vpc_id     = "${aws_vpc.vpc.id}"
  availability_zone = var.azs[count.index]
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 4, count.index + 3)

  tags = {
    Name = "${terraform.workspace}-subnet-${substr(var.azs[count.index], 13, 2)}-pri"
  }
}

resource "aws_subnet" "subnet-nat" {
  count = length(var.azs)

  vpc_id     = "${aws_vpc.vpc.id}"
  availability_zone = var.azs[count.index]
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 4, count.index + 6)

  tags = {
    Name = "${terraform.workspace}-subnet-${substr(var.azs[count.index], 13, 2)}-nat"
  }
}
