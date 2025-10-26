resource "aws_lb" "vpc1_nlb" {
  name               = "${var.project_name}-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets = [
    var.vpc1_private_subnet_1a,
    var.vpc1_private_subnet_1b
  ]

  enable_deletion_protection = false
  tags                       = var.tags
}

resource "aws_lb_target_group" "vpc1_nlb_alb_tg" {
  name        = "${var.project_name}-nlb-alb-tg"
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  depends_on  = [aws_lb_listener.vpc1_alb_listener]
}

resource "aws_lb_listener" "vpc1_nlb_alb_listener" {
  load_balancer_arn = aws_lb.vpc1_nlb.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vpc1_nlb_alb_tg.arn
  }
}