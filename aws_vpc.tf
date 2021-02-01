resource "aws_vpc" "example" {
  cidr_block           = "10.100.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    "Name" = "example"
  }
}

resource "aws_subnet" "example1" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.100.0.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "example1"
  }
}

resource "aws_subnet" "example2" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.100.1.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "example"
  }

}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id

  tags = {
    "Name" = "example"
  }
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }

  tags = {
    "Name" = "example"
  }
}

resource "aws_route_table_association" "example1" {
  subnet_id      = aws_subnet.example1.id
  route_table_id = aws_route_table.example.id
}

resource "aws_route_table_association" "example2" {
  subnet_id      = aws_subnet.example2.id
  route_table_id = aws_route_table.example.id
}