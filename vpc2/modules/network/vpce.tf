resource "aws_vpc_endpoint" "vpc2_vpce" {
  vpc_id              = aws_vpc.vpc2_vpc.id
  service_name        = data.aws_ssm_parameter.vpc1_service_name.value
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = false
  subnet_ids = [aws_subnet.vpc2_private_subnet_1a.id,
  aws_subnet.vpc2_private_subnet_1b.id]
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-interface-vpce"
    }
  )
}

data "aws_ssm_parameter" "vpc1_service_name" {
  name = "/privatelink/service_name"
}