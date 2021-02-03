################################################################################
# Internet Gateway
################################################################################

resource "aws_internet_gateway" "example_1" {
  vpc_id = aws_vpc.example.id

  tags = {
    "Name" = "example_1"
  }
}

################################################################################
# NAT Gateway
################################################################################

resource "aws_nat_gateway" "example_1" {
  allocation_id = aws_eip.nat_gw.id
  subnet_id     = aws_subnet.example_public_1a.id
  depends_on    = [aws_internet_gateway.example_1]

  tags = {
    "Name" = "example_1"
  }
}
