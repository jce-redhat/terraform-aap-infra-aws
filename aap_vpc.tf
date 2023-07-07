data "aws_availability_zones" "this" {
}

locals {
  bastion_subnet_cidr = cidrsubnet(var.aap_vpc_cidr, 2, 0)
  controller_subnet_cidrs = [
    cidrsubnet(var.aap_vpc_cidr, 2, 1),
    cidrsubnet(var.aap_vpc_cidr, 2, 2),
    cidrsubnet(var.aap_vpc_cidr, 2, 3)
  ]
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

resource "aws_subnet" "bastion" {
  vpc_id                  = aws_vpc.aap_vpc.id
  cidr_block              = local.bastion_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name         = "AAP bastion subnet"
    aap_build_id = "${random_id.aap_id.hex}"
  }
}

resource "aws_route_table" "public" {
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

resource "aws_route_table_association" "bastion" {
  subnet_id      = aws_subnet.bastion.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "controller" {
  count = var.controller_count

  vpc_id                  = aws_vpc.aap_vpc.id
  cidr_block              = local.controller_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.this.names[count.index]
  map_public_ip_on_launch = var.disconnected ? false : true

  tags = {
    Name         = "AAP controller subnet ${count.index}"
    aap_build_id = "${random_id.aap_id.hex}"
  }
}

resource "aws_route_table_association" "controller" {
  count = var.controller_count

  subnet_id      = aws_subnet.controller[count.index].id
  route_table_id = aws_route_table.public.id
}

########
resource "aws_route_table" "disconnected" {
  count = var.disconnected ? 1 : 0

  vpc_id = aws_vpc.aap_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[0].id
  }

  tags = {
    Name         = "AAP disconnected route table"
    aap_build_id = "${random_id.aap_id.hex}"
  }
}

resource "aws_route_table_association" "private_controller" {
  count = var.disconnected ? var.controller_count : 0

  subnet_id      = aws_subnet.controller[count.index].id
  route_table_id = aws_route_table.disconnected[0].id
}

resource "aws_eip" "nat" {
  count = var.disconnected ? 1 : 0

  domain     = "vpc"
  depends_on = [aws_internet_gateway.aap_gateway]

  tags = {
    Name         = "AAP Elastic IP for NAT"
    aap_build_id = "${random_id.aap_id.hex}"
  }
}

resource "aws_nat_gateway" "nat" {
  count = var.disconnected ? 1 : 0

  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.bastion.id

  tags = {
    Name         = "AAP disconnected subnet ${count.index} NAT gateway"
    aap_build_id = "${random_id.aap_id.hex}"
  }
}
