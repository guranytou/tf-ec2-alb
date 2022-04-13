################################################################################
# EC2 - Web Server
################################################################################

resource "aws_instance" "example" {
  ami                    = "ami-0992fc94ca0f1415a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.example_instance.id]
  subnet_id              = aws_subnet.example_private_1a.id

  user_data = file("install_apache.sh")

  tags = {
    Name = "example"
  }
}

################################################################################
# Security group - ALB allow
################################################################################

resource "aws_security_group" "example_instance" {
  name   = "example_instance"
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "example_instance"
  }
}

resource "aws_security_group_rule" "sg_ingress_instance" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.example_http.id
  security_group_id        = aws_security_group.example_instance.id
}

resource "aws_security_group_rule" "sg_egress_instance" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.example_instance.id
}



################################################################################
# Load Balancer - Web Server
################################################################################

resource "aws_lb" "example" {
  name                             = "example"
  load_balancer_type               = "application"
  internal                         = false
  idle_timeout                     = 60
  enable_cross_zone_load_balancing = false
  security_groups                  = [aws_security_group.example_http.id]
  subnets = [
    aws_subnet.example_public_1a.id,
    aws_subnet.example_public_1c.id
  ]

  tags = {
    Name = "example"
  }
}

################################################################################
# Load Balancer Listener - Web Server
################################################################################

resource "aws_lb_listener" "example" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example.arn
  }
}

################################################################################
# Target Group - Web Server
################################################################################

resource "aws_lb_target_group" "example" {
  name     = "example"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.example.id

  health_check {
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
    port                = 80
    protocol            = "HTTP"
  }

  depends_on = [aws_lb.example]
}

resource "aws_lb_target_group_attachment" "example" {
  target_group_arn = aws_lb_target_group.example.arn
  target_id        = aws_instance.example.id
  port             = 80
}

################################################################################
# Security group - HTTP allow
################################################################################

resource "aws_security_group" "example_http" {
  name   = "example_http"
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "example_http"
  }
}

resource "aws_security_group_rule" "sg_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["54.65.187.254/32"]
  security_group_id = aws_security_group.example_http.id
}

resource "aws_security_group_rule" "sg_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.example_http.id
}