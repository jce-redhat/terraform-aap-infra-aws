locals {
  aap_public_subnet_cidr  = cidrsubnet(var.aap_vpc_cidr, 2, 0)
  aap_private_subnet_cidr = cidrsubnet(var.aap_vpc_cidr, 2, 1)
}

resource "aws_vpc" "aap_vpc" {
  cidr_block           = var.aap_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name         = "AAP VPC ${random_id.aap_id.hex}"
    aap_build_id = "${random_id.aap_id.hex}"
  }
}

resource "aws_internet_gateway" "aap_gateway" {
  vpc_id = aws_vpc.aap_vpc.id
  tags = {
    Name         = "AAP VPC gateway"
    aap_build_id = "${random_id.aap_id.hex}"
  }
}

resource "aws_eip" "nat_eip" {
  count = var.disconnected ? 1 : 0

  # TODO "vpc" is deprecated here, but the documented replacement 'domain = "vpc"'
  # is failing validation
  vpc        = true
  depends_on = [aws_internet_gateway.aap_gateway]
}

resource "aws_nat_gateway" "nat" {
  count = var.disconnected ? 1 : 0

  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = aws_subnet.public.id
  tags = {
    Name         = "AAP private subnet NAT gateway"
    aap_build_id = "${random_id.aap_id.hex}"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.aap_vpc.id
  cidr_block              = local.aap_public_subnet_cidr
  map_public_ip_on_launch = true
  tags = {
    Name         = "AAP public subnet"
    aap_build_id = "${random_id.aap_id.hex}"
  }
}

resource "aws_route_table" "aap_public_rt" {
  vpc_id = aws_vpc.aap_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aap_gateway.id
  }
  tags = {
    Name         = "AAP public route table"
    aap_build_id = "${random_id.aap_id.hex}"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.aap_public_rt.id
}

resource "aws_subnet" "private" {
  count = var.disconnected ? 1 : 0

  vpc_id                  = aws_vpc.aap_vpc.id
  cidr_block              = local.aap_private_subnet_cidr
  map_public_ip_on_launch = false
  tags = {
    Name         = "AAP private subnet"
    aap_build_id = "${random_id.aap_id.hex}"
  }
}

resource "aws_route_table" "aap_private_rt" {
  count = var.disconnected ? 1 : 0

  vpc_id = aws_vpc.aap_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[0].id
  }
  tags = {
    Name         = "AAP private route table"
    aap_build_id = "${random_id.aap_id.hex}"
  }
}

resource "aws_route_table_association" "private" {
  count = var.disconnected ? 1 : 0

  subnet_id      = aws_subnet.private[0].id
  route_table_id = aws_route_table.aap_private_rt[0].id
}
