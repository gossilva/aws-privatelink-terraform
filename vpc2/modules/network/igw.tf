resource "aws_internet_gateway" "vpc2_igw" {
  vpc_id = aws_vpc.vpc2_vpc.id

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-igw"
    }
  )
}

resource "aws_route_table" "vpc2_public_rtb" {
  vpc_id = aws_vpc.vpc2_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc2_igw.id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-public-rtb"
    }
  )
}