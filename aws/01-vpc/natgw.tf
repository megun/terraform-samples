# NatGateway
resource "aws_eip" "ngw" {
  vpc      = true

  tags = {
    Name = "${terraform.workspace}-eip-ngw"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = "${aws_eip.ngw.id}"
  subnet_id     = "${element(aws_subnet.subnet-pub.*.id, 0)}"

  tags = {
    Name = "${terraform.workspace}-ngw"
  }
}
