# RouteTable
## Public Subnets
resource "aws_route_table" "rt-pub" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags = {
    Name = "${terraform.workspace}-rt-pub"
  }
}

resource "aws_route_table_association" "pub" {
  count = length(var.azs)
  subnet_id      = "${element(aws_subnet.subnet-pub.*.id, count.index)}"
  route_table_id = "${aws_route_table.rt-pub.id}"
}

## Private Subnets
resource "aws_route_table" "rt-pri" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "${terraform.workspace}-rt-pri"
  }
}

resource "aws_route_table_association" "pri" {
  count = length(var.azs)
  subnet_id      = "${element(aws_subnet.subnet-pri.*.id, count.index)}"
  route_table_id = "${aws_route_table.rt-pri.id}"
}

## Nat Subnets
resource "aws_route_table" "rt-nat" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.ngw.id}"
  }

  tags = {
    Name = "${terraform.workspace}-rt-nat"
  }
}

resource "aws_route_table_association" "nat" {
  count = length(var.azs)
  subnet_id      = "${element(aws_subnet.subnet-nat.*.id, count.index)}"
  route_table_id = "${aws_route_table.rt-nat.id}"
}
