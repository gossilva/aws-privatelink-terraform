output "public_subnet_1a" {
  value = aws_subnet.vpc1_public_subnet_1a.id
}

output "public_subnet_1b" {
  value = aws_subnet.vpc1_public_subnet_1b.id
}

output "private_subnet_1a" {
  value = aws_subnet.vpc1_private_subnet_1a.id
}

output "private_subnet_1b" {
  value = aws_subnet.vpc1_private_subnet_1b.id
}

output "vpc_id" {
  value = aws_vpc.vpc1_vpc.id
}