resource "aws_ssm_parameter" "vpc1_ssm_service_name" {
  name  = "/privatelink/service_name"
  type  = "String"
  value = aws_vpc_endpoint_service.vpc1_vpce_service.service_name

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-ssm-service-name"
    }
  )
}