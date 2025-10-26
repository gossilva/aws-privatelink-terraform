resource "aws_instance" "vpc2_ec2" {
  subnet_id            = var.vpc2_private_subnet_1a
  ami                  = "ami-0341d95f75f311023"
  instance_type        = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.vpc2_ec2_instance_profile.name

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-ec2"
    }
  )
}

