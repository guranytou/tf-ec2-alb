resource "aws_vpc" "ec2-alb-vpc" {
  cidr_block = "10.200.0.0/16"

  tags = {
    Name = "ec2-alb-vpc"
  }
}

resource "aws_subnet" "ec2-alb-private" {
  vpc_id     = aws_vpc.ec2-alb-vpc.id
  cidr_block = "10.200.1.0/24"

  tags = {
    Name = "ec2-alb-private"
  }
}

resource "aws_network_interface" "ec2-alb-interface" {
  subnet_id  = aws_subnet.ec2-alb-private.id
  private_ip = "10.200.1.1"
  tags = {
    Name = "ec2-alb-interface"
  }
}