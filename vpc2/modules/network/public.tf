resource "aws_subnet" "vpc2_public_subnet_1a" {
  vpc_id                  = aws_vpc.vpc2_vpc.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, 1)
  availability_zone       = "${data.aws_region.current.region}a"
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-public-subnet-1a"
    }
  )
}

resource "aws_subnet" "vpc2_public_subnet_1b" {
  vpc_id                  = aws_vpc.vpc2_vpc.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, 2)
  availability_zone       = "${data.aws_region.current.region}b"
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-public-subnet-1b"
    }
  )
}

resource "aws_route_table_association" "vpc2_public_rtb_assoc_1a" {
  subnet_id      = aws_subnet.vpc2_public_subnet_1a.id
  route_table_id = aws_route_table.vpc2_public_rtb.id
}

resource "aws_route_table_association" "vpc2_public_rtb_assoc_1b" {
  subnet_id      = aws_subnet.vpc2_public_subnet_1b.id
  route_table_id = aws_route_table.vpc2_public_rtb.id
}