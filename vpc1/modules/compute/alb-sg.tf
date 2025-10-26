resource "aws_security_group" "vpc1_alb_sg" {
  description = "Security group for public ALB"
  vpc_id      = var.vpc_id
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-alb-sg"
    }
  )

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}