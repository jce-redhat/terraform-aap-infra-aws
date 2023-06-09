resource "aws_security_group" "bastion" {
  name        = "aap-bastion-${random_id.aap_id.hex}"
  description = "AAP bastion ingress rules"
  vpc_id      = aws_vpc.aap_vpc.id
  ingress {
    description = "SSH"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    aap_build_id = "${random_id.aap_id.hex}"
  }
}

resource "aws_security_group" "public_subnet" {
  name        = "aap-public-subnet-${random_id.aap_id.hex}"
  description = "Rules for all instances on the AAP public subnet"
  vpc_id      = aws_vpc.aap_vpc.id
  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = flatten([
      var.aap_public_subnet_cidr,
      var.disconnected ? [var.aap_private_subnet_cidr] : []
    ])
  }
  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = [
      var.aap_public_subnet_cidr,
      var.aap_private_subnet_cidr
    ]
  }

  tags = {
    aap_build_id = "${random_id.aap_id.hex}"
  }
}

resource "aws_security_group" "private_subnet" {
  count = var.disconnected ? 1 : 0

  name        = "aap-private-subnet-${random_id.aap_id.hex}"
  description = "Rules for all instances on the AAP private subnet"
  vpc_id      = aws_vpc.aap_vpc.id
  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = [
      var.aap_public_subnet_cidr,
      var.aap_private_subnet_cidr
    ]
  }
  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = [
      var.aap_public_subnet_cidr,
      var.aap_private_subnet_cidr
    ]
  }

  tags = {
    aap_build_id = "${random_id.aap_id.hex}"
  }
}
