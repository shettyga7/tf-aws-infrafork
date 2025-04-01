# ALB Resource
resource "aws_lb" "web_alb" {
  name                       = "webapp-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.lb_sg.id]
  subnets                    = aws_subnet.public_subnets[*].id
  enable_deletion_protection = false

  tags = {
    Name = "WebApp-ALB"
  }
}

# ALB Target Group
resource "aws_lb_target_group" "web_tg" {
  name     = "webapp-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id

  health_check {
    path                = "/healthz"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "WebApp-TG"
  }
}

# ALB Listener
resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}