resource "aws_launch_template" "vpc1_launch_template" {
  name          = "${var.project_name}-launch-template"
  image_id      = "ami-0341d95f75f311023"
  instance_type = "t3.micro"

  monitoring {
    enabled = true
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-launch-template"
    }
  )

  tag_specifications {
    resource_type = "instance"
    tags = merge(
      var.tags,
      {
        Name = "${var.project_name}-backend-ec2"
      }
    )
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.vpc1_asg_sg.id]
  }

  user_data = base64encode(file("${path.module}/userdata.sh"))

}

resource "aws_autoscaling_group" "vpc1_asg" {
  name             = "${var.project_name}-asg"
  desired_capacity = 1
  max_size         = 1
  min_size         = 1
  vpc_zone_identifier = [var.vpc1_private_subnet_1a,
  var.vpc1_private_subnet_1b]

  launch_template {
    id      = aws_launch_template.vpc1_launch_template.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "vpc1_asg_alb_attach" {
  autoscaling_group_name = aws_autoscaling_group.vpc1_asg.id
  lb_target_group_arn    = aws_lb_target_group.vpc1_alb_tg.arn
}