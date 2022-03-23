resource "aws_subnet" "private_a" {
  cidr_block        = var.cidr_block_private_a
  vpc_id            = aws_vpc.main.id
  availability_zone = "${data.aws_region.current.name}a"

  tags = merge(
    var.common_tags,
    tomap({ "Name" = "${var.prefix}-private-a" })
  )
}

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    tomap({ "Name" = "${var.prefix}-rt-private-a" })
  )
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_a.id
}

resource "aws_route" "private_a" {
  route_table_id         = aws_route_table.private_a.id
  nat_gateway_id         = aws_nat_gateway.public_a.id
  destination_cidr_block = "0.0.0.0/0"
}