resource "aws_vpc_endpoint_service" "vpc1_vpce_service" {
  acceptance_required        = false
  network_load_balancer_arns = [var.vpc1_nlb]
  #private_dns_name = "api.123"
  #allowed_principals        = ["arn:aws:iam::123456789012:root"]
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-vpce-service"
    }
  )
}