resource "aws_lb" "vpc1_alb" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.vpc1_alb_sg.id]
  subnets = [
    var.vpc1_public_subnet_1a,
    var.vpc1_public_subnet_1b
  ]

  enable_deletion_protection = false

  tags = var.tags
}

resource "aws_lb_target_group" "vpc1_alb_tg" {
  name     = "${var.project_name}-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  tags     = var.tags
}

resource "aws_lb_listener" "vpc1_alb_listener" {
  load_balancer_arn = aws_lb.vpc1_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vpc1_alb_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "vpc1_nlb_alb_tg_attach" {
  target_group_arn = aws_lb_target_group.vpc1_nlb_alb_tg.arn
  target_id        = aws_lb.vpc1_alb.id
  depends_on       = [aws_lb_listener.vpc1_alb_listener]
}