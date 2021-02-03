################################################################################
# Subnet - public
################################################################################

resource "aws_subnet" "example_public_1a" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.100.0.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "example_public_1a"
  }
}

resource "aws_subnet" "example_public_1c" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.100.1.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "example_public_1c"
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
    "Name" = "example_private_1"
  }
}