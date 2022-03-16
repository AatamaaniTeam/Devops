#Creating VPC
resource "aws_vpc" "team-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "team-vpc"
  }
}
#Creating Subnets
resource "aws_subnet" "public-subnet-1" {
  vpc_id     = "${aws_vpc.team-vpc.id}"
  cidr_block = "10.0.0.0/20"
  map_public_ip_on_launch = "true" //it makes this a public subnet
  availability_zone = "us-west-2a"

  tags = {
    Name = "team-publicsubnet-1"
  }
}
resource "aws_subnet" "public-subnet-2" {
  vpc_id     = "${aws_vpc.team-vpc.id}"
  cidr_block = "10.0.16.0/20"
  map_public_ip_on_launch = "true" //it makes this a public subnet
  availability_zone = "us-west-2b"

  tags = {
    Name = "team-publicsubnet-2"
  }
}
resource "aws_subnet" "public-subnet-3" {
  vpc_id     = "${aws_vpc.team-vpc.id}"
  cidr_block = "10.0.32.0/20"
  map_public_ip_on_launch = "true" //it makes this a public subnet
  availability_zone = "us-west-2c"

  tags = {
    Name = "team-publicsubnet-3"
  }
}

#these are private subnets 
resource "aws_subnet" "private-subnet-1" {
  vpc_id     = "${aws_vpc.team-vpc.id}"
  cidr_block = "10.0.48.0/20"
  availability_zone = "us-west-2a"

  tags = {
    Name = "team-Privatesubnet-1"
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id     = "${aws_vpc.team-vpc.id}"
  cidr_block = "10.0.64.0/20"
  availability_zone = "us-west-2b"

  tags = {
    Name = "team-Privatesubnet-2"
  }
}

