################################################################################
# Elastic IP - Web Server(NAT Gateway)
################################################################################

resource "aws_eip" "nat_gw" {
  vpc = true
}
