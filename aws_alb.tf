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
    "Name" = "example"
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
  target_id        = aws_instance.example_1.id
  port             = 80
}