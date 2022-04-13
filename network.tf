################################################################################
# VPC
################################################################################

resource "aws_vpc" "example" {
  cidr_block = "10.100.0.0/16"

  tags = {
    Name = "example"
  }
}

################################################################################
# Subnet - public
################################################################################

resource "aws_subnet" "example_public_1a" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.100.0.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "example_public_1a"
  }
}

resource "aws_subnet" "example_public_1c" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.100.1.0/24"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "example_public_1c"
  }
}

################################################################################
# Subnet - private
################################################################################

resource "aws_subnet" "example_private_1a" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.100.100.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "example_private_1"
  }
}


################################################################################
# Internet Gateway
################################################################################

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "example"
  }
}

################################################################################
# NAT Gateway
################################################################################

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.nat_gw.id
  subnet_id     = aws_subnet.example_public_1a.id
  depends_on    = [aws_internet_gateway.example]

  tags = {
    Name = "example"
  }
}

################################################################################
# Elastic IP - Web Server(NAT Gateway)
################################################################################

resource "aws_eip" "nat_gw" {
  vpc = true
}


################################################################################
# Route Table - Public
################################################################################

resource "aws_route_table" "example_internet_gw" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "example_route_internet_gw"
  }
}

resource "aws_route" "example_internet_gw_default" {
  route_table_id         = aws_route_table.example_internet_gw.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.example.id
}

resource "aws_route_table_association" "example_internet_gw_1a" {
  subnet_id      = aws_subnet.example_public_1a.id
  route_table_id = aws_route_table.example_internet_gw.id
}

resource "aws_route_table_association" "example_internet_gw_1c" {
  subnet_id      = aws_subnet.example_public_1c.id
  route_table_id = aws_route_table.example_internet_gw.id
}

################################################################################
# Route Table - Private
################################################################################

resource "aws_route_table" "example_private" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "example_route_private"
  }
}

resource "aws_route" "example_private_default" {
  route_table_id         = aws_route_table.example_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.example.id
}

resource "aws_route_table_association" "example_private_1" {
  subnet_id      = aws_subnet.example_private_1a.id
  route_table_id = aws_route_table.example_private.id
}