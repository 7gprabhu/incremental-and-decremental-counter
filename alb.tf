resource "aws_lb" "my_alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups   = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet.id]
}

resource "aws_lb_target_group" "ec2_target_group" {
  name     = "ec2-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    status_code      = "200"
    content_type     = "text/plain"
  }
}

resource "aws_lb_listener_rule" "target_group_rule" {
  listener_arn = aws_lb_listener.http_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}
