resource "aws_vpc" "aap_vpc" {
  cidr_block           = var.aap_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name         = "AAP VPC"
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

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.aap_vpc.id
  cidr_block              = var.aap_public_subnet_cidr
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
  cidr_block              = var.aap_private_subnet_cidr
  map_public_ip_on_launch = false
  tags = {
    Name         = "AAP private subnet"
    aap_build_id = "${random_id.aap_id.hex}"
  }
}

resource "aws_route_table" "aap_private_rt" {
  count = var.disconnected ? 1 : 0

  vpc_id = aws_vpc.aap_vpc.id
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
