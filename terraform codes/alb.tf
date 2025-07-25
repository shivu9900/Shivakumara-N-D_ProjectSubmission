# ALB Security Group (allow HTTP from anywhere)
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP access from internet"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "Allow HTTP from all"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}

# ALB Target Group
resource "aws_lb_target_group" "public_tg" {
  name        = "public-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.this.id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "public-target-group"
  }
}

# ALB Load Balancer
resource "aws_lb" "app_alb" {
  name               = "upgrad-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public1.id, aws_subnet.public2.id]

  tags = {
    Name = "upgrad-alb"
  }
}

# ALB Listener
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public_tg.arn
  }
}

# Attach public EC2 to Target Group
resource "aws_lb_target_group_attachment" "public_instance_attachment" {
  target_group_arn = aws_lb_target_group.public_tg.arn
  target_id        = aws_instance.public.id
  port             = 80
}
