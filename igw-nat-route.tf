#creating elastice-ip
resource "aws_eip" "team-eip" {
  vpc      = "true"
  tags = {
    Name = "team-eip"
  }
}
#creating nat-gateway
resource "aws_nat_gateway" "team-nat" {
  allocation_id = "${aws_eip.team-eip.id}"
  subnet_id     = "${aws_subnet.public-subnet-1.id}"

  tags = {
    Name = "team-NAT"
  }
}
#creating internet-gateway
resource "aws_internet_gateway" "team-igw" {
  vpc_id = "${aws_vpc.team-vpc.id}"

  tags = {
    Name = "team-igw"
  }
}
#creating route-tables
resource "aws_route_table" "team-rt" {
  vpc_id = "${aws_vpc.team-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.team-igw.id}"
  }

  tags = {
    Name = "team-rt"
  }
}

#creating route-tables-two
resource "aws_route_table" "team-rt-2" {
  vpc_id = "${aws_vpc.team-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.team-nat.id}"
  }

  tags = {
    Name = "team-rt-2"
  }
}

resource "aws_route_table_association" "team-associate-rt" {
    subnet_id = "${aws_subnet.public-subnet-1.id}"
    route_table_id = "${aws_route_table.team-rt.id}"
}

resource "aws_route_table_association" "team-associate-rt-2" {
    subnet_id = "${aws_subnet.public-subnet-2.id}"
    route_table_id = "${aws_route_table.team-rt.id}"
}

resource "aws_route_table_association" "team-associate-rt-3" {
    subnet_id = "${aws_subnet.public-subnet-3.id}"
    route_table_id = "${aws_route_table.team-rt.id}"
}

resource "aws_route_table_association" "team-associate-rt-4" {
    subnet_id = "${aws_subnet.private-subnet-1.id}"
    route_table_id = "${aws_route_table.team-rt-2.id}"
}

resource "aws_route_table_association" "team-associate-rt-5" {
    subnet_id = "${aws_subnet.private-subnet-2.id}"
    route_table_id = "${aws_route_table.team-rt-2.id}"
}

