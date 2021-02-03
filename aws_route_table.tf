################################################################################
# Route Table - Public
################################################################################

resource "aws_route_table" "example_internet_gw" {
  vpc_id = aws_vpc.example.id

  tags = {
    "Name" = "example_route_internet_gw"
  }
}

resource "aws_route" "example_internet_gw_default" {
  route_table_id         = aws_route_table.example_internet_gw.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.example_1.id
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
    "Name" = "example_route_private"
  }
}

resource "aws_route" "example_private_default" {
  route_table_id         = aws_route_table.example_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.example_1.id
}

resource "aws_route_table_association" "example_private_1" {
  subnet_id      = aws_subnet.example_private_1a.id
  route_table_id = aws_route_table.example_private.id
}