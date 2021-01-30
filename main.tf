terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.24"
    }
  }
}

provider "aws" {

}

resource "aws_instance" "example" {
  ami                    = "ami-0992fc94ca0f1415a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.example_ec2.id]
  subnet_id              = aws_subnet.example.id

  user_data = file("install_apache.sh")

  tags = {
    "Name" = "example"
  }
}

resource "aws_security_group" "example_ec2" {
  name   = "example_ec2"
  vpc_id = aws_vpc.example.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    cidr_blocks = ["60.239.203.70/32"]
    from_port   = -1
    protocol    = "icmp"
    to_port     = -1
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc" "example" {
  cidr_block           = "10.100.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
}

resource "aws_subnet" "example" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.100.0.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }
}

resource "aws_route_table_association" "name" {
  subnet_id      = aws_subnet.example.id
  route_table_id = aws_route_table.example.id
}

output "example_public_dns" {
  value = aws_instance.example.public_dns
}