################################################################################
# EC2 - Web Server
################################################################################

resource "aws_instance" "example_1" {
  ami                    = "ami-0992fc94ca0f1415a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.example_http.id]
  subnet_id              = aws_subnet.example_private_1a.id

  user_data = file("install_apache.sh")

  tags = {
    "Name" = "example_1"
  }
}