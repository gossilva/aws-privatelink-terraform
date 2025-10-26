resource "aws_security_group" "vpc1_asg_sg" {
  description = "Security group for public ASG"
  vpc_id      = var.vpc_id
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-asg-sg"
    }
  )

  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.vpc1_alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}