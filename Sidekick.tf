resource "aws_route_table" "RT_Private_subnet1" {
  vpc_id = "${aws_vpc.andy_vpc.id}"

  route {
    cidr_block     = "${var.route_table_private_cidr}"
    nat_gateway_id = "${aws_nat_gateway.NAT_AY.id}"
  }

  tags = {
    Name = "Andy_Private_RT"
  }
}

resource "aws_route_table_association" "PR" {
  subnet_id      = "${aws_subnet.Private_Subnet.id}"
  route_table_id = "${aws_route_table.RT_Private_subnet1.id}"
}

resource "aws_route_table" "RT_Public_subnet2" {
  vpc_id = "${aws_vpc.andy_vpc.id}"

  route {
    cidr_block     = "${var.route_table_public_cidr}"
    nat_gateway_id = "${aws_nat_gateway.NAT_AY.id}"
  }

  tags = {
    Name = "Andy_Public_RT"
  }
}

resource "aws_route_table_association" "PU" {
  subnet_id      = "${aws_subnet.Public_Subnet.id}"
  route_table_id = "${aws_route_table.RT_Public_subnet2.id}"
}

resource "aws_security_group" "EC2_SG" {
  name        = "aws_security_group.EC2_SG"
  description = "Opening network to the world but Limiting network only within Plus3IT"
  vpc_id      = "${aws_vpc.andy_vpc.id}"

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["173.10.166.169/32"]
  }

  egress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "ANDY_EC2_Security_group"
  }
}

resource "aws_nat_gateway" "NAT_AY" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.Private_Subnet.id}"

  tags {
    Name = "AndyY_Nat"
  }
}

resource "aws_eip" "nat" {
  vpc = true

  tags {
    Name = "AY_EIP"
  }
}
