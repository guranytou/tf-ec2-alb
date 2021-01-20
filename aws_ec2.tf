resource "aws_instance" "web1" {
  ami           = "ami-01748a72bed07727c"
  instance_type = "t2.micro"
  monitoring    = true

  network_interface {
    network_interface_id = aws_network_interface.ec2-alb-interface.id
    device_index         = 0
  }

  tags = {
    Name = "web1"
  }
}