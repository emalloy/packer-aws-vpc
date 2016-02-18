provider "aws" {
}

resource "aws_vpc" "packer-ami" {
  cidr_block = "10.19.0.0/16"
  enable_dns_support = true

  tags {
    Name = "packer-ami"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.packer-ami.id}"
}


# Public subnets

resource "aws_subnet" "us-east-1b-public" {
  vpc_id = "${aws_vpc.packer-ami.id}"

  cidr_block = "10.19.20.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_subnet" "us-east-1d-public" {
  vpc_id = "${aws_vpc.packer-ami.id}"

  cidr_block = "10.19.21.0/24"
  availability_zone = "us-east-1d"
}

# Routing table for public subnets

resource "aws_route_table" "us-east-1-public" {
  vpc_id = "${aws_vpc.packer-ami.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }
}

resource "aws_route_table_association" "us-east-1b-public" {
  subnet_id = "${aws_subnet.us-east-1b-public.id}"
  route_table_id = "${aws_route_table.us-east-1-public.id}"
}

resource "aws_route_table_association" "us-east-1d-public" {
  subnet_id = "${aws_subnet.us-east-1d-public.id}"
  route_table_id = "${aws_route_table.us-east-1-public.id}"
}
