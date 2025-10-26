resource "aws_subnet" "vpc1_private_subnet_1a" {
  vpc_id            = aws_vpc.vpc1_vpc.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, 3)
  availability_zone = "${data.aws_region.current.region}a"

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-private-subnet-1a"
    }
  )
}

resource "aws_subnet" "vpc1_private_subnet_1b" {
  vpc_id            = aws_vpc.vpc1_vpc.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, 4)
  availability_zone = "${data.aws_region.current.region}b"

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-private-subnet-1b"
    }
  )
}

resource "aws_route_table_association" "vpc1_private_rtb_assoc_1a" {
  subnet_id      = aws_subnet.vpc1_private_subnet_1a.id
  route_table_id = aws_route_table.vpc1_private_rtb_1a.id
}

resource "aws_route_table_association" "vpc1_private_rtb_assoc_1b" {
  subnet_id      = aws_subnet.vpc1_private_subnet_1b.id
  route_table_id = aws_route_table.vpc1_private_rtb_1b.id
}