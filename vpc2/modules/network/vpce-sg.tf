resource "aws_security_group" "vpc2_vpce_sg" {
  description = "Security group for Interface VPC Endpoint"
  vpc_id      = aws_vpc.vpc2_vpc.id
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-vpce-sg"
    }
  )

  ingress {
    description = "Allow HTTP from EC2"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}