resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    var.common_tags,
    tomap({ "Name" = "${var.prefix}-vpc" })
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.common_tags,
    tomap({ "Name" = "${var.prefix}-igw-main" })
  )
}

data "aws_region" "current" {}