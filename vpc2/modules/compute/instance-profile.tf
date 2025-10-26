resource "aws_iam_instance_profile" "vpc2_ec2_instance_profile" {
  name = "${var.project_name}-ec2-instance-profile"
  role = aws_iam_role.vpc2_ec2_ssm_role.name
}

data "aws_iam_policy_document" "vpc2_ec2_ssm_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "vpc2_ec2_ssm_role" {
  name               = "${var.project_name}-ec2-ssm-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.vpc2_ec2_ssm_policy.json
}

resource "aws_iam_role_policy_attachment" "vpc2_ec2_ssm_role_attach" {
  role       = aws_iam_role.vpc2_ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}