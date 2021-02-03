################################################################################
# VPC
################################################################################

resource "aws_vpc" "example" {
  cidr_block           = "10.100.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    "Name" = "example"
  }
}
