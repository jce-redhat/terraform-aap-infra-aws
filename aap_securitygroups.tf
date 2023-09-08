resource "aws_security_group" "bastion" {
  name        = "aap-bastion-${random_id.aap_id.hex}"
  description = "AAP bastion ingress rules"
  vpc_id      = aws_vpc.aap_vpc.id
  ingress {
    description = "SSH"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    aap_build_id = "${random_id.aap_id.hex}"
  }
}

resource "aws_security_group" "controller" {
  name        = "aap-controller-${random_id.aap_id.hex}"
  description = "AAP controller ingress rules"
  vpc_id      = aws_vpc.aap_vpc.id
  ingress {
    description = "HTTPS"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  ingress {
    description = "Automation Mesh"
    from_port   = "21799"
    to_port     = "21799"
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    aap_build_id = "${random_id.aap_id.hex}"
  }
}

resource "aws_security_group" "hub" {
  name        = "aap-hub-${random_id.aap_id.hex}"
  description = "AAP hub ingress rules"
  vpc_id      = aws_vpc.aap_vpc.id
  ingress {
    description = "HTTPS"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    aap_build_id = "${random_id.aap_id.hex}"
  }
}

resource "aws_security_group" "edacontroller" {
  name        = "aap-edacontroller-${random_id.aap_id.hex}"
  description = "AAP EDA controller ingress rules"
  vpc_id      = aws_vpc.aap_vpc.id
  ingress {
    description = "HTTPS"
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  ingress {
    description = "Webhook ports"
    from_port   = "5000"
    to_port     = "5010"
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_security_group" "database" {
  name        = "aap-database-${random_id.aap_id.hex}"
  description = "AAP database ingress rules"
  vpc_id      = aws_vpc.aap_vpc.id
  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_security_group" "execution" {
  name        = "aap-execution-${random_id.aap_id.hex}"
  description = "AAP execution node ingress rules"
  vpc_id      = aws_vpc.aap_vpc.id
  ingress {
    description = "Automation Mesh"
    from_port   = "27199"
    to_port     = "27199"
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

resource "aws_security_group" "aap_subnets" {
  name        = "aap-subnets-${random_id.aap_id.hex}"
  description = "Rules for intra-VPC connections between subnets"
  vpc_id      = aws_vpc.aap_vpc.id
  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = flatten([
      local.bastion_subnet_cidr,
      local.controller_subnet_cidrs
    ])
  }
  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = flatten([
      local.bastion_subnet_cidr,
      local.controller_subnet_cidrs
    ])
  }

  tags = {
    aap_build_id = "${random_id.aap_id.hex}"
  }
}
