resource "aws_subnet" "public_a" {
  cidr_block              = var.cidr_block_public_a
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "${var.avail_zone}a"

  tags = merge(
    var.common_tags,
    tomap({ "Name" = "${var.prefix}-public-a" })
  )
}

resource "aws_route_table" "public_a" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.common_tags,
    tomap({ "Name" = "${var.prefix}-rt-public-a" })
  )
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_a.id
}

resource "aws_route" "public_a" {
  route_table_id         = aws_route_table.public_a.id
  gateway_id             = aws_internet_gateway.main.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_eip" "public_a" {
  vpc = true

  tags = merge(
    var.common_tags,
    tomap({ "Name" = "${var.prefix}-eip-public-a" })
  )
}

resource "aws_nat_gateway" "public_a" {
  allocation_id = aws_eip.public_a.id
  subnet_id     = aws_subnet.public_a.id

  tags = merge(
    var.common_tags,
    tomap({ "Name" = "${var.prefix}-nat-public-a" })
  )
}