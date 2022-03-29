resource "aws_lb" "nginx" {
  name               = "${var.prefix}-main"
  load_balancer_type = "application"
  subnets            = var.public_subnets
  internal           = var.internal

  security_groups = [aws_security_group.lb.id]
  tags            = var.common_tags
}

resource "aws_lb_target_group" "nginx" {
  name     = "${var.prefix}-nginx"
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  port     = 80

  health_check {
    path = "/"
  }

  depends_on = [
    aws_lb.nginx
  ]
}

resource "aws_lb_listener" "nginx" {
  load_balancer_arn = aws_lb.nginx.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }
}

resource "aws_security_group" "lb" {
  description = "Allow access to application Load Balancer"
  name        = "${var.prefix}-lb"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
}