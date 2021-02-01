resource "aws_instance" "example" {
  ami                    = "ami-0992fc94ca0f1415a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.example_ec2.id]
  subnet_id              = aws_subnet.example1.id

  user_data = file("install_apache.sh")

  tags = {
    "Name" = "example"
  }
}