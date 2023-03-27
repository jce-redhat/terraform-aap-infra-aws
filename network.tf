resource "aws_vpc" "aap_vpc" {
  cidr_block           = "10.255.0.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name     = "AAP VPC"
    build_id = "${random_id.aap_id.hex}"
  }
}

resource "aws_internet_gateway" "aap_gateway" {
  vpc_id = aws_vpc.aap_vpc.id
  tags = {
    Name     = "AAP VPC gateway"
    build_id = "${random_id.aap_id.hex}"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.aap_vpc.id
  cidr_block              = "10.255.0.0/26"
  map_public_ip_on_launch = true
  tags = {
    Name     = "AAP public subnet"
    build_id = "${random_id.aap_id.hex}"
  }
}

resource "aws_route_table" "aap_rt" {
  vpc_id = aws_vpc.aap_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aap_gateway.id
  }
  tags = {
    Name     = "AAP route table"
    build_id = "${random_id.aap_id.hex}"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.aap_rt.id
}
