resource "aws_lb" "python_lb" {
  name               = "python-lb"
  internal           = false
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.alb_sg.id]
  load_balancer_type = "application"
  tags = {
    Name = "terraform-demo"
  }
}

resource "aws_lb_target_group" "python_tg" {
  name        = "python-tg"
  port        = 5000
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"
  tags = {
    Name = "terraform-demo"
  }
}

resource "aws_lb_listener" "python_listener" {
  load_balancer_arn = aws_lb.python_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.python_tg.arn
  }
  tags = {
    Name = "terraform-demo"
  }
  depends_on = [aws_lb_listener.python_listener]
}
